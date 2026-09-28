import { NextResponse } from 'next/server';
import { createVerificationSession } from '@/lib/deviceVerification/verificationStore';
import { generateSessionQRCode, buildVerificationUrls } from '@/lib/deviceVerification/qrHelper';

export const dynamic = 'force-dynamic';

export async function POST(request: Request) {
  try {
    let body: any;
    try {
      body = await request.json();
    } catch {
      body = {};
    }

    const { selectedDevice, userId, sellFlowId } = body;

    if (!selectedDevice || !selectedDevice.brand || !selectedDevice.model) {
      return NextResponse.json(
        { success: false, message: 'selectedDevice with brand and model is required' },
        { status: 400 }
      );
    }

    const session = await createVerificationSession({
      userId,
      sellFlowId,
      selectedDevice,
    });

    const host = request.headers.get('host') || '';
    const protocol = request.headers.get('x-forwarded-proto') || 'https';
    const baseUrl = `${protocol}://${host}`;

    const { webUrl, deepLink } = buildVerificationUrls(session.sessionId, baseUrl);
    const qrCodeDataUrl = await generateSessionQRCode(webUrl);

    session.webVerificationUrl = webUrl;
    session.appDeepLink = deepLink;

    return NextResponse.json({
      success: true,
      session,
      qrCodeDataUrl,
      webUrl,
      deepLink,
    });
  } catch (err: any) {
    console.error('Create verification session error:', err);
    return NextResponse.json(
      { success: false, message: err?.message || 'Failed to create verification session' },
      { status: 500 }
    );
  }
}
