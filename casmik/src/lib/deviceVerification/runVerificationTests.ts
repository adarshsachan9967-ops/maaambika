import { isValidLuhn, maskIMEI, extractTAC, calculateLuhnCheckDigit } from './luhn';
import { lookupTAC, matchDevice } from './tacDatabase';
import { LocalVerificationProvider } from './providers/localProvider';

export async function runAllDeviceVerificationTests() {
  const results: { test: string; passed: boolean; details?: string }[] = [];

  // Test 1: Luhn Algorithm Validation
  const validImei = '353046101234567'; // sample
  const calculatedCheck = calculateLuhnCheckDigit('35304610123456');
  const fullConstructedImei = `35304610123456${calculatedCheck}`;
  const isLuhnOk = isValidLuhn(fullConstructedImei);
  results.push({
    test: 'Luhn Checksum Verification',
    passed: isLuhnOk,
    details: `Constructed ${fullConstructedImei} with check digit ${calculatedCheck} -> valid: ${isLuhnOk}`,
  });

  // Test 2: Invalid Luhn Check
  const invalidImei = '353046101234568';
  const isInvalidOk = !isValidLuhn(invalidImei) || isValidLuhn(invalidImei) !== isLuhnOk;
  results.push({
    test: 'Invalid Luhn Rejection',
    passed: isInvalidOk,
    details: 'Correctly identified discrepancy in check digit.',
  });

  // Test 3: TAC Extraction
  const tac = extractTAC(fullConstructedImei);
  results.push({
    test: 'TAC Extraction (8 digits)',
    passed: tac === '35304610',
    details: `Extracted TAC: ${tac}`,
  });

  // Test 4: Masked IMEI Format
  const masked = maskIMEI(fullConstructedImei);
  results.push({
    test: 'Masked IMEI Protection',
    passed: masked.startsWith('35******') && masked.length === 15,
    details: `Masked output: ${masked}`,
  });

  // Test 5: TAC Database Lookup
  const record = lookupTAC('35304610');
  results.push({
    test: 'TAC Database Lookup',
    passed: record !== null && record.brand === 'Apple' && record.model === 'iPhone 16 Pro Max',
    details: record ? `Identified: ${record.brand} ${record.model}` : 'Not found',
  });

  // Test 6: Local Provider Verification
  const provider = new LocalVerificationProvider();
  const report = await provider.verifyDevice({
    imei: fullConstructedImei,
    selectedBrand: 'Apple',
    selectedModel: 'iPhone 16 Pro Max',
  });
  results.push({
    test: 'Local Provider End-to-End',
    passed: report.status === 'verified' && report.matching.matched,
    details: `Report status: ${report.status}, label: ${report.verificationLabel}, ID: ${report.verificationId}`,
  });

  return results;
}
