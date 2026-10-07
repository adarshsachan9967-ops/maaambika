// Partner Wallet & Escrow Balance Management
export interface WalletTransaction {
  id: string;
  partnerId: string;
  amount: number;
  type: 'credit' | 'debit';
  reason: string;
  orderNumber?: string;
  createdAt: string;
}

const DEFAULT_PARTNER_BALANCES: Record<string, number> = {
  'partner-001': 45000,
  'partner-002': 38500,
  'partner-003': 52000,
};

export function getPartnerWalletBalance(partnerId: string): number {
  if (typeof window === 'undefined') return DEFAULT_PARTNER_BALANCES[partnerId] || 35000;
  try {
    const saved = localStorage.getItem(`casmik_partner_wallet_${partnerId}`);
    if (saved !== null) {
      const parsed = parseFloat(saved);
      if (!isNaN(parsed)) return parsed;
    }
  } catch {}
  return DEFAULT_PARTNER_BALANCES[partnerId] || 35000;
}

export function setPartnerWalletBalance(partnerId: string, newBalance: number): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(`casmik_partner_wallet_${partnerId}`, Math.max(0, newBalance).toString());
    window.dispatchEvent(new CustomEvent('casmik_wallet_updated', {
      detail: { partnerId, balance: newBalance }
    }));
  } catch (err) {
    console.error('Failed to set partner wallet balance:', err);
  }
}

export function checkPartnerWalletSufficiency(partnerId: string, requiredAmount: number): {
  sufficient: boolean;
  currentBalance: number;
  shortfall: number;
} {
  const currentBalance = getPartnerWalletBalance(partnerId);
  const sufficient = currentBalance >= requiredAmount;
  const shortfall = sufficient ? 0 : requiredAmount - currentBalance;
  return { sufficient, currentBalance, shortfall };
}

export function deductPartnerWalletBalance(
  partnerId: string,
  amount: number,
  orderNumber?: string,
  reason: string = 'Customer Doorstep Payout'
): boolean {
  const currentBalance = getPartnerWalletBalance(partnerId);
  if (currentBalance < amount) {
    return false; // Insufficient funds
  }

  const updatedBalance = currentBalance - amount;
  setPartnerWalletBalance(partnerId, updatedBalance);

  // Log transaction
  if (typeof window !== 'undefined') {
    try {
      const txKey = `casmik_partner_wallet_txns_${partnerId}`;
      const existing: WalletTransaction[] = JSON.parse(localStorage.getItem(txKey) || '[]');
      const newTx: WalletTransaction = {
        id: `tx-${Date.now()}`,
        partnerId,
        amount,
        type: 'debit',
        reason: `${reason} ${orderNumber ? `(#${orderNumber})` : ''}`.trim(),
        orderNumber,
        createdAt: new Date().toISOString(),
      };
      localStorage.setItem(txKey, JSON.stringify([newTx, ...existing]));
    } catch {}
  }

  return true;
}

export function addPartnerWalletBalance(
  partnerId: string,
  amount: number,
  reason: string = 'Wallet Top-up'
): number {
  const currentBalance = getPartnerWalletBalance(partnerId);
  const updatedBalance = currentBalance + amount;
  setPartnerWalletBalance(partnerId, updatedBalance);

  if (typeof window !== 'undefined') {
    try {
      const txKey = `casmik_partner_wallet_txns_${partnerId}`;
      const existing: WalletTransaction[] = JSON.parse(localStorage.getItem(txKey) || '[]');
      const newTx: WalletTransaction = {
        id: `tx-${Date.now()}`,
        partnerId,
        amount,
        type: 'credit',
        reason,
        createdAt: new Date().toISOString(),
      };
      localStorage.setItem(txKey, JSON.stringify([newTx, ...existing]));
    } catch {}
  }

  return updatedBalance;
}
