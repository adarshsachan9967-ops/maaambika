import { DeviceVerificationProvider } from './interface';
import { DeviceVerificationReport, VerificationInput, BlacklistStatus, DeviceVerificationLabel } from '../types';
import { LocalVerificationProvider } from './localProvider';
import { isValidLuhn, maskIMEI, extractTAC, generateVerificationId } from '../luhn';
import { matchDevice } from '../tacDatabase';

export class IMEIInfoProvider implements DeviceVerificationProvider {
  name = 'IMEI.info Cloud Verification Engine';

  private apiKey: string;
  private baseUrl: string;
  private enabled: boolean;
  private timeoutMs: number;
  private localFallback: LocalVerificationProvider;

  constructor() {
    this.apiKey = process.env.IMEI_INFO_API_KEY || '';
    this.baseUrl = process.env.IMEI_INFO_BASE_URL || 'https://api.imei.info/v1';
    this.enabled = process.env.IMEI_INFO_ENABLED === 'true';
    this.timeoutMs = parseInt(process.env.IMEI_INFO_TIMEOUT || '10000', 10);
    this.localFallback = new LocalVerificationProvider();
  }

  isAvailable(): boolean {
    return this.enabled && !!this.apiKey;
  }

  async verifyDevice(input: VerificationInput): Promise<DeviceVerificationReport> {
    if (!this.isAvailable()) {
      return this.localFallback.verifyDevice(input);
    }

    const rawImei = (input.imei || '').trim().replace(/\D/g, '');
    const luhnPassed = isValidLuhn(rawImei);
    const tac = extractTAC(rawImei);
    const maskedImei = maskIMEI(rawImei);
    const timestamp = new Date().toISOString();
    const verificationId = generateVerificationId();

    if (!luhnPassed || rawImei.length !== 15) {
      return this.localFallback.verifyDevice(input);
    }

    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), this.timeoutMs);

      const endpoint = `${this.baseUrl}/check?imei=${encodeURIComponent(rawImei)}`;
      const response = await fetch(endpoint, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Accept': 'application/json',
        },
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        // Fall back gracefully to local provider
        const fallbackReport = await this.localFallback.verifyDevice(input);
        fallbackReport.notes.push(`External IMEI.info returned status ${response.status}. Fallback applied.`);
        return fallbackReport;
      }

      const data = await response.json();

      const detectedBrand = data.brand || data.manufacturer || input.selectedBrand;
      const detectedModel = data.model || data.deviceName || input.selectedModel;
      const detectedStorage = data.storage || input.selectedStorage;

      const detectedDevice = {
        brand: detectedBrand,
        manufacturer: data.manufacturer || detectedBrand,
        model: detectedModel,
        marketingName: data.marketingName || detectedModel,
        modelNumber: data.modelNumber,
        os: data.os,
        storage: detectedStorage,
        deviceType: data.deviceType || 'Smartphone',
      };

      const matching = matchDevice(
        {
          brand: input.selectedBrand,
          model: input.selectedModel,
          variant: input.selectedVariant,
          storage: input.selectedStorage,
        },
        detectedDevice
      );

      let blacklistStatus: BlacklistStatus = 'clean';
      let blacklistRecord: { source?: string; timestamp?: string; reason?: string } | undefined;

      if (data.blacklist === true || data.status === 'BLACKLISTED' || data.isBlacklisted) {
        blacklistStatus = 'blacklisted';
        blacklistRecord = {
          source: 'IMEI.info GSMA Global Registry',
          timestamp: new Date().toISOString(),
          reason: data.blacklistReason || 'The selected verification source returned a blacklist record.',
        };
      }

      let status: DeviceVerificationReport['status'] = 'verified';
      let verificationLabel: DeviceVerificationLabel = 'DEVICE VERIFIED';

      if (blacklistStatus === 'blacklisted') {
        status = 'failed';
        verificationLabel = 'BLACKLISTED';
      } else if (!matching.matched) {
        status = 'mismatch';
        verificationLabel = 'POTENTIAL MISMATCH';
      } else {
        verificationLabel = 'DEVICE VERIFIED';
      }

      return {
        verificationId,
        sessionId: input.sessionId,
        status,
        verificationLabel,
        source: 'imei-info',
        providerName: this.name,
        timestamp,
        device: detectedDevice,
        identifiers: {
          imei1: rawImei,
          imei2: input.imei2 ? input.imei2.trim().replace(/\D/g, '') : undefined,
          maskedImei,
          tac,
          luhnValid: true,
        },
        matching,
        security: {
          blacklistStatus,
          blacklistRecord,
          carrier: data.carrier || 'Unlocked / Global',
          carrierLock: data.simLock ? 'Locked' : 'Unlocked',
          warrantyStatus: data.warranty || 'Check with OEM',
          activationStatus: data.activation || 'Activated',
        },
        notes: [
          'External IMEI.info API query verified.',
          `Provider response timestamp: ${timestamp}`,
        ],
      };
    } catch (err: any) {
      const fallbackReport = await this.localFallback.verifyDevice(input);
      fallbackReport.notes.push(`IMEI.info query skipped (${err?.message || 'timeout'}). Local validation successful.`);
      return fallbackReport;
    }
  }
}
