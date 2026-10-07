# Maa Ambika Ecosystem

Maa Ambika is an all-in-one platform for device buyback, refurbished device sales, repairs, partner management, and delivery logistics.

## Project Structure

```
maaambika/
├── maaambika/           # Next.js 15 Web Application & Backend API
├── maaambika-admin/     # Flutter Admin Management App
├── maaambika-user/      # Flutter Customer / User App
├── maaambika-delivery/  # Flutter Executive / Delivery App
├── maaambika-partner/   # Flutter Partner / Merchant App
├── atlas-credentials.env# MongoDB Atlas Credentials
├── .env                 # Project Environment Configuration
└── .env.example         # Environment Template
```

## Tech Stack & Integrations

- **Web Frontend & API**: Next.js 15, React 19, Tailwind CSS, TypeScript
- **Mobile Applications**: Flutter & Dart (Sizer, GoRouter, CachedNetworkImage)
- **Database**: MongoDB Atlas
- **Storage & CDN**: ImageKit (Folder: `maaambika`)
- **Authentication**: Supabase SSR / Client Auth

## Getting Started

### Web App (`maaambika`)
```bash
cd maaambika
npm install
npm run dev
```

### Mobile Apps (`maaambika-admin`, `maaambika-user`, `maaambika-delivery`, `maaambika-partner`)
```bash
cd maaambika-admin # or maaambika-user, maaambika-delivery, maaambika-partner
flutter pub get
flutter run
```
