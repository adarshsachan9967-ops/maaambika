import QRCode from 'qrcode';

/**
 * Generates data URL of QR code for a given verification session URL.
 */
export async function generateSessionQRCode(url: string): Promise<string> {
  try {
    return await QRCode.toDataURL(url, {
      width: 280,
      margin: 2,
      color: {
        dark: '#0f172a',
        light: '#ffffff',
      },
      errorCorrectionLevel: 'M',
    });
  } catch (err) {
    console.error('QR generation error:', err);
    // Return empty fallback SVG string data URI if error
    return '';
  }
}

/**
 * Constructs deep link and web URL for mobile app handoff.
 */
export function buildVerificationUrls(sessionId: string, baseUrl?: string): { webUrl: string; deepLink: string } {
  const host = baseUrl || process.env.NEXT_PUBLIC_APP_URL || 'https://casmik-one.vercel.app';
  const webUrl = `${host.replace(/\/$/, '')}/verify-device/${sessionId}`;
  const deepLink = `maaambika://verify-device?sessionId=${encodeURIComponent(sessionId)}`;
  return { webUrl, deepLink };
}
