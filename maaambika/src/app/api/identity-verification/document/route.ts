import { NextResponse } from 'next/server';
import { getAadhaarSession, recordDocumentUpload } from '@/lib/aadhaarVerification/store';
import { headers } from 'next/headers';
import crypto from 'crypto';
import { writeFile, mkdir } from 'fs/promises';
import path from 'path';

export const dynamic = 'force-dynamic';

// Max file size: 5MB per file
const MAX_FILE_SIZE = 5 * 1024 * 1024;

// Allowed MIME types for Aadhaar documents
const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'application/pdf'];

// Server-only secure upload directory (never served publicly)
const SECURE_UPLOAD_DIR = process.env.AADHAAR_SECURE_UPLOAD_PATH || '/tmp/aadhaar-secure';

function hashBuffer(buf: Buffer): string {
  return crypto.createHash('sha256').update(buf).digest('hex');
}

async function saveSecurely(buffer: Buffer, originalName: string, sessionId: string, slot: string): Promise<string> {
  const ext = path.extname(originalName) || '.bin';
  const filename = `${sessionId}_${slot}_${crypto.randomBytes(8).toString('hex')}${ext}`;
  const dir = path.join(SECURE_UPLOAD_DIR, sessionId.slice(0, 8));
  await mkdir(dir, { recursive: true });
  const filePath = path.join(dir, filename);
  await writeFile(filePath, buffer, { mode: 0o600 });
  return filePath; // stored as internal ref, never exposed to client
}

export async function POST(request: Request) {
  try {
    const formData = await request.formData().catch(() => null);
    if (!formData) {
      return NextResponse.json({ success: false, message: 'Invalid form data' }, { status: 400 });
    }

    const sessionId = formData.get('sessionId') as string;
    const userId = formData.get('userId') as string;

    if (!sessionId || !userId) {
      return NextResponse.json({ success: false, message: 'sessionId and userId are required' }, { status: 400 });
    }

    const aadhaarSession = await getAadhaarSession(sessionId);
    if (!aadhaarSession || aadhaarSession.userId !== userId) {
      return NextResponse.json({ success: false, message: 'Session not found or unauthorized' }, { status: 403 });
    }
    if (aadhaarSession.status !== 'consent_given' && aadhaarSession.status !== 'document_uploaded') {
      return NextResponse.json({ success: false, message: 'Consent must be recorded before uploading documents.' }, { status: 400 });
    }

    const frontFile = formData.get('front') as File | null;
    const backFile = formData.get('back') as File | null;
    const selfieFile = formData.get('selfie') as File | null;

    if (!frontFile) {
      return NextResponse.json({ success: false, message: 'Aadhaar front image is required.' }, { status: 400 });
    }

    // Validate file sizes and types
    for (const [slot, file] of [['front', frontFile], ['back', backFile], ['selfie', selfieFile]] as [string, File | null][]) {
      if (!file) continue;
      if (!ALLOWED_TYPES.includes(file.type)) {
        return NextResponse.json({ success: false, message: `File "${slot}" type not allowed. Use JPEG, PNG, WebP, or PDF.` }, { status: 400 });
      }
      if (file.size > MAX_FILE_SIZE) {
        return NextResponse.json({ success: false, message: `File "${slot}" exceeds 5MB limit.` }, { status: 400 });
      }
    }

    const headersList = await headers();
    const uploadIp = headersList.get('x-forwarded-for') || headersList.get('x-real-ip') || undefined;

    // Read + hash + securely save files
    const frontBuf = Buffer.from(await frontFile.arrayBuffer());
    const frontHash = hashBuffer(frontBuf);
    const frontRef = await saveSecurely(frontBuf, frontFile.name, sessionId, 'front');

    let backRef: string | undefined;
    let backHash: string | undefined;
    if (backFile) {
      const backBuf = Buffer.from(await backFile.arrayBuffer());
      backHash = hashBuffer(backBuf);
      backRef = await saveSecurely(backBuf, backFile.name, sessionId, 'back');
    }

    let selfieRef: string | undefined;
    let selfieHash: string | undefined;
    if (selfieFile) {
      const selfieBuf = Buffer.from(await selfieFile.arrayBuffer());
      selfieHash = hashBuffer(selfieBuf);
      selfieRef = await saveSecurely(selfieBuf, selfieFile.name, sessionId, 'selfie');
    }

    const docRef = await recordDocumentUpload(sessionId, userId, aadhaarSession.userType, {
      frontImageRef: frontRef,
      backImageRef: backRef,
      selfieImageRef: selfieRef,
      fileHashes: { front: frontHash, back: backHash, selfie: selfieHash },
      uploadedFromIp: uploadIp,
    });

    return NextResponse.json({
      success: true,
      message: 'Documents uploaded successfully. Your identity is now under review.',
      documentRef: docRef,
      // IMPORTANT: Never return image refs, paths, or hashes to client
    });
  } catch (err: any) {
    console.error('[aadhaar/document POST]', err?.message);
    return NextResponse.json({ success: false, message: 'Upload failed. Please try again.' }, { status: 500 });
  }
}
