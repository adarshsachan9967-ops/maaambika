import { getClientPromise } from '@/lib/mongodb';
import crypto from 'crypto';

export type AadhaarVerificationStatus =
  | 'pending_consent'
  | 'consent_given'
  | 'document_uploaded'
  | 'under_review'
  | 'verified'
  | 'rejected';

export interface AadhaarConsentRecord {
  givenAt: string;         // ISO timestamp
  ipAddress?: string;
  userAgent?: string;
  consentText: string;
  explicitConsent: boolean;
}

export interface AadhaarVerificationSession {
  sessionId: string;
  userId: string;              // Partner or Delivery person userId
  userType: 'partner' | 'delivery';
  status: AadhaarVerificationStatus;
  createdAt: string;
  updatedAt: string;
  expiresAt: string;           // Sessions expire in 7 days
  consent?: AadhaarConsentRecord;
  documentRef?: string;        // ObjectId ref to aadhaar_verification_documents
  reviewNotes?: string;
  reviewedBy?: string;         // Admin userId who reviewed
  reviewedAt?: string;
  // Masked data (stored after review, NEVER full Aadhaar)
  maskedAadhaarNumber?: string;  // e.g. XXXX XXXX 1234
  verifiedName?: string;
  verifiedAt?: string;
}

export interface AadhaarDocumentRecord {
  sessionId: string;
  userId: string;
  userType: 'partner' | 'delivery';
  uploadedAt: string;
  // Secure encrypted field references (actual images stored server-side only)
  frontImageRef: string;        // Path or GCS ref — NEVER sent to client
  backImageRef?: string;
  selfieImageRef?: string;
  encryptionKeyRef?: string;    // Key ID for field-level encryption
  fileHashes: {
    front: string;
    back?: string;
    selfie?: string;
  };
  uploadedFromIp?: string;
}

// ─── Database helpers ────────────────────────────────────────────────────────

async function getDb() {
  const client = await getClientPromise();
  return client.db();
}

export async function createAadhaarSession(
  userId: string,
  userType: 'partner' | 'delivery'
): Promise<AadhaarVerificationSession> {
  const db = await getDb();
  const sessionId = `AAV-${Date.now()}-${crypto.randomBytes(6).toString('hex').toUpperCase()}`;
  const now = new Date().toISOString();
  const expires = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();

  // Reuse existing pending session if any
  const existing = await db.collection<AadhaarVerificationSession>('aadhaar_verification_sessions').findOne({
    userId,
    userType,
    status: { $in: ['pending_consent', 'consent_given', 'document_uploaded', 'under_review'] },
    expiresAt: { $gt: now },
  });

  if (existing) {
    return { ...existing, _id: undefined } as unknown as AadhaarVerificationSession;
  }

  const session: AadhaarVerificationSession = {
    sessionId,
    userId,
    userType,
    status: 'pending_consent',
    createdAt: now,
    updatedAt: now,
    expiresAt: expires,
  };

  await db.collection('aadhaar_verification_sessions').insertOne(session);
  return session;
}

export async function getAadhaarSession(sessionId: string): Promise<AadhaarVerificationSession | null> {
  const db = await getDb();
  const doc = await db.collection<AadhaarVerificationSession>('aadhaar_verification_sessions').findOne({ sessionId });
  if (!doc) return null;
  const { _id, ...rest } = doc as any;
  return rest;
}

export async function getActiveAadhaarSession(userId: string, userType: 'partner' | 'delivery'): Promise<AadhaarVerificationSession | null> {
  const db = await getDb();
  const now = new Date().toISOString();
  const doc = await db.collection<AadhaarVerificationSession>('aadhaar_verification_sessions').findOne(
    { userId, userType, expiresAt: { $gt: now } },
    { sort: { createdAt: -1 } }
  );
  if (!doc) return null;
  const { _id, ...rest } = doc as any;
  return rest;
}

export async function updateAadhaarSession(
  sessionId: string,
  updates: Partial<AadhaarVerificationSession>
): Promise<void> {
  const db = await getDb();
  await db.collection('aadhaar_verification_sessions').updateOne(
    { sessionId },
    { $set: { ...updates, updatedAt: new Date().toISOString() } }
  );
}

export async function recordConsent(
  sessionId: string,
  consent: AadhaarConsentRecord
): Promise<void> {
  await updateAadhaarSession(sessionId, { consent, status: 'consent_given' });
}

export async function recordDocumentUpload(
  sessionId: string,
  userId: string,
  userType: 'partner' | 'delivery',
  documentData: Omit<AadhaarDocumentRecord, 'sessionId' | 'userId' | 'userType' | 'uploadedAt'>
): Promise<string> {
  const db = await getDb();
  const doc: AadhaarDocumentRecord = {
    sessionId,
    userId,
    userType,
    uploadedAt: new Date().toISOString(),
    ...documentData,
  };
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const result = await db.collection('aadhaar_verification_documents').insertOne(doc as any);
  const docRef = result.insertedId.toString();
  await updateAadhaarSession(sessionId, { status: 'document_uploaded', documentRef: docRef });
  return docRef;
}

export async function getAadhaarSessionsForReview(userType?: 'partner' | 'delivery') {
  const db = await getDb();
  const filter: any = { status: 'document_uploaded' };
  if (userType) filter.userType = userType;
  const docs = await db.collection('aadhaar_verification_sessions').find(filter).sort({ updatedAt: 1 }).toArray();
  return docs.map(({ _id, ...rest }) => rest);
}

export async function adminReviewSession(
  sessionId: string,
  decision: 'verified' | 'rejected',
  reviewedBy: string,
  maskedAadhaarNumber?: string,
  verifiedName?: string,
  reviewNotes?: string
): Promise<void> {
  const now = new Date().toISOString();
  await updateAadhaarSession(sessionId, {
    status: decision,
    reviewedBy,
    reviewedAt: now,
    reviewNotes,
    ...(decision === 'verified'
      ? { maskedAadhaarNumber, verifiedName, verifiedAt: now }
      : {}),
  });
}

// Check if a user's Aadhaar verification is confirmed (for payment gating)
export async function isAadhaarVerified(userId: string, userType: 'partner' | 'delivery'): Promise<boolean> {
  const db = await getDb();
  const count = await db.collection('aadhaar_verification_sessions').countDocuments({
    userId,
    userType,
    status: 'verified',
  });
  return count > 0;
}
