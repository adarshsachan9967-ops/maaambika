import { NextResponse } from 'next/server';
import { getAadhaarSessionsForReview, getAadhaarSession, adminReviewSession } from '@/lib/aadhaarVerification/store';

export const dynamic = 'force-dynamic';

// Simple admin auth check — validates against env-based admin secret or localStorage admin session
// In production, replace this with proper server-side admin session validation
async function isAdminRequest(request: Request): Promise<boolean> {
  const adminToken = request.headers.get('x-admin-token');
  const expectedToken = process.env.ADMIN_API_TOKEN;
  if (expectedToken && adminToken === expectedToken) return true;
  // Fallback: also allow if admin secret header present (for dev)
  return adminToken === 'maa-ambika-admin-2024';
}

// GET /api/identity-verification/admin — list sessions pending review
export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const userType = searchParams.get('userType') as 'partner' | 'delivery' | undefined;
    const sessions = await getAadhaarSessionsForReview(userType || undefined);
    return NextResponse.json({ success: true, sessions });
  } catch (err: any) {
    return NextResponse.json({ success: false, message: err?.message || 'Error' }, { status: 500 });
  }
}

// POST /api/identity-verification/admin — approve or reject a session
export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { sessionId, reviewedBy, decision, maskedAadhaarNumber, verifiedName, reviewNotes } = body;

    if (!sessionId || !['verified', 'rejected'].includes(decision)) {
      return NextResponse.json({ success: false, message: 'sessionId and decision (verified|rejected) required' }, { status: 400 });
    }

    if (decision === 'verified' && (!maskedAadhaarNumber || !verifiedName)) {
      return NextResponse.json({
        success: false,
        message: 'maskedAadhaarNumber (e.g. XXXX XXXX 1234) and verifiedName are required for approval',
      }, { status: 400 });
    }

    // Validate maskedAadhaarNumber format — must NOT be full 12-digit Aadhaar
    if (maskedAadhaarNumber) {
      const fullMatch = maskedAadhaarNumber.replace(/\s/g, '').match(/^\d{12}$/);
      if (fullMatch) {
        return NextResponse.json({
          success: false,
          message: 'Full Aadhaar numbers must never be stored. Use masked format: XXXX XXXX 1234',
        }, { status: 400 });
      }
    }

    const aadhaarSession = await getAadhaarSession(sessionId);
    if (!aadhaarSession) {
      return NextResponse.json({ success: false, message: 'Session not found' }, { status: 404 });
    }

    await adminReviewSession(
      sessionId,
      decision,
      reviewedBy || 'admin',
      maskedAadhaarNumber,
      verifiedName,
      reviewNotes
    );

    return NextResponse.json({
      success: true,
      message: `Session ${decision} successfully.`,
      sessionId,
      decision,
    });
  } catch (err: any) {
    console.error('[aadhaar/admin POST]', err?.message);
    return NextResponse.json({ success: false, message: 'Review failed' }, { status: 500 });
  }
}
