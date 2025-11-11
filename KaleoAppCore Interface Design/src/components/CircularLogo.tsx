import React from 'react';

interface CircularLogoProps {
  size?: number;
  backgroundColor?: string;
  borderColor?: string;
  borderWidth?: number;
  className?: string;
}

export const CircularLogo: React.FC<CircularLogoProps> = ({
  size = 60,
  backgroundColor = 'white',
  borderColor,
  borderWidth = 0,
  className = '',
}) => {
  const logoStyle: React.CSSProperties = {
    width: size,
    height: size,
    borderRadius: '50%',
    backgroundColor,
    border: borderColor ? `${borderWidth}px solid ${borderColor}` : 'none',
    boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
    objectFit: 'cover' as any,
  };

  return (
    <div className={`circular-logo ${className}`} style={logoStyle}>
      <img
        src="/logo.jpg"
        alt="Kaleo Logo"
        style={{
          width: '100%',
          height: '100%',
          objectFit: 'cover',
          borderRadius: '50%',
        }}
        onError={(e) => {
          // Fallback si no se puede cargar la imagen
          const target = e.target as HTMLImageElement;
          target.style.display = 'none';
          const parent = target.parentElement;
          if (parent) {
            parent.innerHTML = `
              <div style="
                width: 100%;
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: #f3f4f6;
                color: #6b7280;
                font-size: ${size * 0.3}px;
              ">
                <svg width="${size * 0.4}" height="${size * 0.4}" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                </svg>
              </div>
            `;
          }
        }}
      />
    </div>
  );
};
