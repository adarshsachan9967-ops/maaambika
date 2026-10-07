import React from 'react';
import type { Metadata, Viewport } from 'next';
import { Plus_Jakarta_Sans } from 'next/font/google';
import '../styles/tailwind.css';
import { Toaster } from 'sonner';
import { AuthProvider } from '@/contexts/AuthContext';

const plusJakartaSans = Plus_Jakarta_Sans({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  variable: '--font-plus-jakarta-sans',
  display: 'swap',
});

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
};

export const metadata: Metadata = {
  title: 'Maa Ambika Mobile Shop — Your Digital Life Partner | Smartphones, Certified Refurbished, Repairs & Accessories',
  description: 'Maa Ambika Mobile Shop — Your Digital Life Partner. Best products, best prices, best service! Buy latest smartphones, certified refurbished phones, instant doorstep sell & exchange, expert mobile repairs, original accessories & recharge. Mob: +91 8260120467, GSTIN: 21ELDPS6270L1ZS.',
  keywords: 'Maa Ambika Mobile Shop, mobile shop near me, buy smartphones, sell old phone, mobile repair, phone exchange, certified refurbished phones, iPhone, Samsung Galaxy, OnePlus, mobile accessories, mobile recharge, GSTIN 21ELDPS6270L1ZS, 8260120467',
  icons: {
    icon: [{ url: '/assets/images/app_logo.png', type: 'image/png' }],
  },
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en" className={plusJakartaSans.variable}>
      <body className={plusJakartaSans.className}>
        <AuthProvider>
          {children}
        </AuthProvider>
        <Toaster position="bottom-right" richColors closeButton />
      </body>
    </html>
  );
}