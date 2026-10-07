import { DeviceVerificationProvider } from './interface';
import { LocalVerificationProvider } from './localProvider';
import { IMEIInfoProvider } from './imeiInfoProvider';

let activeProviderInstance: DeviceVerificationProvider | null = null;

export function getDeviceVerificationProvider(): DeviceVerificationProvider {
  if (activeProviderInstance) {
    return activeProviderInstance;
  }

  const configuredEngine = process.env.IMEI_PROVIDER;
  if (configuredEngine === 'imei-info') {
    const imeiInfo = new IMEIInfoProvider();
    if (imeiInfo.isAvailable()) {
      activeProviderInstance = imeiInfo;
      return activeProviderInstance;
    }
  }

  activeProviderInstance = new LocalVerificationProvider();
  return activeProviderInstance;
}
