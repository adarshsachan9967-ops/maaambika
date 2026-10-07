import { NextResponse } from 'next/server';
import { getVerificationReport } from '@/lib/deviceVerification/verificationStore';

export const dynamic = 'force-dynamic';

export async function GET(
  _request: Request,
  { params }: { params: Promise<{ verificationId: string }> }
) {
  try {
    const { verificationId } = await params;
    if (!verificationId) {
      return NextResponse.json({ success: false, message: 'verificationId is required' }, { status: 400 });
    }

    const report = await getVerificationReport(verificationId);
    if (!report) {
      return NextResponse.json({ success: false, message: 'Verification report not found' }, { status: 404 });
    }

    return NextResponse.json({ success: true, report });
  } catch (err: any) {
    return NextResponse.json({ success: false, message: err?.message || 'Error fetching report' }, { status: 500 });
  }
}
