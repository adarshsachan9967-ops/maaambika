import { NextResponse } from 'next/server';
import { createAadhaarSession, getActiveAadhaarSession } from '@/lib/aadhaarVerification/store';

export const dynamic = 'force-dynamic';

export async function POST(request: Request) {
  try {
    const body = await request.json().catch(() => ({}));
    const { userId, userType } = body;

    if (!userId) {
      return NextResponse.json({ success: false, message: 'userId is required' }, { status: 400 });
    }

    const type: 'partner' | 'delivery' = userType === 'delivery' ? 'delivery' : 'partner';
    const aadhaarSession = await createAadhaarSession(userId, type);
    return NextResponse.json({ success: true, session: aadhaarSession });
  } catch (err: any) {
    console.error('[aadhaar/session POST]', err?.message);
    return NextResponse.json({ success: false, message: 'Error creating session' }, { status: 500 });
  }
}

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('userId');
    const userType: 'partner' | 'delivery' = searchParams.get('userType') === 'delivery' ? 'delivery' : 'partner';

    if (!userId) {
      return NextResponse.json({ success: false, message: 'userId is required' }, { status: 400 });
    }

    const aadhaarSession = await getActiveAadhaarSession(userId, userType);
    return NextResponse.json({ success: true, session: aadhaarSession });
  } catch (err: any) {
    return NextResponse.json({ success: false, message: err?.message || 'Error' }, { status: 500 });
  }
}
