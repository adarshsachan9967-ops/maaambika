import { NextResponse } from 'next/server';
import { getAadhaarSession, recordConsent } from '@/lib/aadhaarVerification/store';
import { headers } from 'next/headers';

export const dynamic = 'force-dynamic';

const CONSENT_TEXT =
  'I hereby voluntarily consent to the collection, processing, and secure storage of my Aadhaar number and associated documents for the purpose of identity verification by Maa Ambika Services. I understand this data will be processed in compliance with applicable Indian laws including DPDP Act 2023 and the Aadhaar Act 2016. I confirm I am the lawful holder of the Aadhaar number being submitted. My consent may be withdrawn at any time by contacting Maa Ambika customer support.';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { sessionId, userId, explicitConsent } = body;

    if (!sessionId || !userId || typeof explicitConsent !== 'boolean') {
      return NextResponse.json({ success: false, message: 'sessionId, userId, and explicitConsent are required' }, { status: 400 });
    }

    if (!explicitConsent) {
      return NextResponse.json({ success: false, message: 'You must give explicit consent to proceed.' }, { status: 400 });
    }

    const aadhaarSession = await getAadhaarSession(sessionId);
    if (!aadhaarSession) {
      return NextResponse.json({ success: false, message: 'Session not found' }, { status: 404 });
    }
    if (aadhaarSession.userId !== userId) {
      return NextResponse.json({ success: false, message: 'Unauthorized — session does not belong to this user' }, { status: 403 });
    }
    if (aadhaarSession.status !== 'pending_consent') {
      return NextResponse.json({ success: true, message: 'Consent already recorded', session: aadhaarSession });
    }

    const headersList = await headers();
    const consentRecord = {
      givenAt: new Date().toISOString(),
      ipAddress: headersList.get('x-forwarded-for') || headersList.get('x-real-ip') || undefined,
      userAgent: headersList.get('user-agent') || undefined,
      consentText: CONSENT_TEXT,
      explicitConsent: true,
    };

    await recordConsent(sessionId, consentRecord);
    return NextResponse.json({ success: true, message: 'Consent recorded', consentText: CONSENT_TEXT });
  } catch (err: any) {
    console.error('[aadhaar/consent POST]', err?.message);
    return NextResponse.json({ success: false, message: 'Error recording consent' }, { status: 500 });
  }
}
