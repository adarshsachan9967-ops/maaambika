import { NextResponse } from 'next/server';
import { getVerificationSession } from '@/lib/deviceVerification/verificationStore';

export const dynamic = 'force-dynamic';

export async function GET(
  _request: Request,
  { params }: { params: Promise<{ sessionId: string }> }
) {
  try {
    const { sessionId } = await params;
    if (!sessionId) {
      return NextResponse.json({ success: false, message: 'sessionId is required' }, { status: 400 });
    }

    const session = await getVerificationSession(sessionId);
    if (!session) {
      return NextResponse.json({ success: false, message: 'Verification session not found' }, { status: 404 });
    }

    return NextResponse.json({
      success: true,
      session,
    });
  } catch (err: any) {
    return NextResponse.json({ success: false, message: err?.message || 'Error fetching session' }, { status: 500 });
  }
}
