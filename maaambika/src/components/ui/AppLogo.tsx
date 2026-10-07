'use client';

import React, { memo, useMemo } from 'react';
import AppIcon from './AppIcon';
import AppImage from './AppImage';

interface AppLogoProps {
  src?: string; // Image source (optional)
  iconName?: string; // Icon name when no image
  size?: number; // Size for icon/image
  className?: string; // Additional classes
  onClick?: () => void; // Click handler
  showBadge?: boolean;
}

const AppLogo = memo(function AppLogo({
  src = '/assets/images/app_logo.png',
  iconName = 'SparklesIcon',
  size = 64,
  className = '',
  onClick,
  showBadge = false,
}: AppLogoProps) {
  // Memoize className calculation
  const containerClassName = useMemo(() => {
    const classes = ['flex items-center gap-2 relative'];
    if (onClick) classes.push('cursor-pointer hover:opacity-90 transition-opacity');
    if (className) classes.push(className);
    return classes.join(' ');
  }, [onClick, className]);

  return (
    <div className={containerClassName} onClick={onClick}>
      {/* Show image if src provided, otherwise show icon */}
      {src ? (
        <div className="relative inline-flex items-center justify-center">
          <AppImage
            src={src}
            alt="Maa Ambika Mobile Shop Logo" 
            width={size}
            height={size}
            className="flex-shrink-0 object-contain drop-shadow-[0_4px_12px_rgba(217,119,6,0.35)] rounded-xl"
            priority={true}
            unoptimized={src.endsWith('.svg')}
          />
          {showBadge && (
            <span className="absolute -bottom-1 -right-1 px-1.5 py-0.5 text-[9px] font-black uppercase tracking-wider bg-gradient-to-r from-amber-500 to-yellow-400 text-slate-950 rounded-full border border-white shadow-sm">
              Verified
            </span>
          )}
        </div>
      ) : (
        <AppIcon name={iconName} size={size} className="flex-shrink-0" />
      )}
    </div>
  );
});

export default AppLogo;
