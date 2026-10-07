import { NextResponse } from 'next/server';
import { getDeviceVerificationProvider } from '@/lib/deviceVerification/providers';
import { saveVerificationReport, getVerificationSession, updateVerificationSession } from '@/lib/deviceVerification/verificationStore';

export const dynamic = 'force-dynamic';

export async function POST(request: Request) {
  try {
    let body: any;
    try {
      body = await request.json();
    } catch {
      body = {};
    }

    const { imei, imei2, selectedBrand, selectedModel, selectedVariant, selectedStorage, sessionId } = body;

    if (!imei) {
      return NextResponse.json(
        { success: false, message: 'IMEI number is required' },
        { status: 400 }
      );
    }
    if (!selectedBrand || !selectedModel) {
      return NextResponse.json(
        { success: false, message: 'selectedBrand and selectedModel are required for device matching' },
        { status: 400 }
      );
    }

    const provider = getDeviceVerificationProvider();
    const report = await provider.verifyDevice({
      imei,
      imei2,
      selectedBrand,
      selectedModel,
      selectedVariant,
      selectedStorage,
      sessionId,
    });

    // Save report to database & cache
    await saveVerificationReport(report);

    // If session ID provided, mark session as completed
    if (sessionId) {
      const session = await getVerificationSession(sessionId);
      if (session) {
        await updateVerificationSession(sessionId, {
          status: report.status === 'verified' ? 'completed' : 'failed',
          deviceDetected: true,
          imeiVerified: report.identifiers.luhnValid,
          deviceMatched: report.matching.matched,
          verificationReport: report,
        });
      }
    }

    return NextResponse.json({
      success: report.status === 'verified',
      status: report.status,
      verificationLabel: report.verificationLabel,
      report,
    });
  } catch (err: any) {
    console.error('Validate IMEI API error:', err);
    return NextResponse.json(
      { success: false, message: err?.message || 'Server error while validating IMEI' },
      { status: 500 }
    );
  }
}
