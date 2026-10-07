# Maa Ambika Delivery Application (Maa Ambika Fleet)

Official delivery executive application for the Maa Ambika ecosystem (`in.maaambika.delivery`).

## Architecture Overview

```
lib/
├── app.dart                                # MaaAmbikaDeliveryApp (theme, scaffoldMessengerKey, root screen)
├── main.dart                               # Application entrypoint (runZonedGuarded, StorageService.init)
├── core/
│   ├── constants/
│   │   ├── api_constants.dart              # Endpoints & base URL
│   │   ├── app_constants.dart              # Brand theme colors, typography, symbols
│   │   └── app_keys.dart                   # Storage and session keys
│   ├── services/
│   │   ├── api_service.dart                # Delivery tasks, earnings & status API
│   │   └── storage_service.dart            # SharedPreferencesService wrapper
│   └── utils/
│       ├── currency_formatter.dart         # Currency formatting utility
│       └── helpers.dart                    # showSuccessSnackbar & showErrorSnackbar
├── data/
│   ├── fallback/
│   │   └── fallback_delivery_data.dart     # Mock tasks list, earnings stats, hotspots, notifications
│   └── models/
│       ├── delivery_task.dart              # Task model & checklist tracking
│       ├── earnings_summary.dart           # Wallet balance & trip earnings models
│       └── hotspot.dart                    # High-demand pickup areas & drop-off hubs
├── modules/
│   ├── tasks/
│   │   ├── widgets/
│   │   │   ├── shift_stats_card.dart       # Shift summary banner
│   │   │   ├── task_card.dart              # Individual pickup/delivery card
│   │   │   ├── inspection_bottom_sheet.dart# Handover checklist modal
│   │   │   └── otp_verification_dialog.dart# Customer 4-digit OTP dialog
│   │   └── delivery_tasks_screen.dart      # Tasks list tab
│   ├── earnings/
│   │   ├── widgets/
│   │   │   ├── wallet_balance_card.dart    # Available balance & instant payout
│   │   │   ├── incentive_card.dart         # Super shift incentive challenge
│   │   │   └── trip_earning_tile.dart      # Trip earning record
│   │   └── delivery_earnings_screen.dart   # Earnings tab
│   ├── hotspots/
│   │   ├── widgets/
│   │   │   ├── hotspot_card.dart           # Demand hotspot card
│   │   │   └── hub_card.dart               # Drop-off hub card
│   │   └── delivery_hotspots_screen.dart   # Demand hotspots tab
│   ├── profile/
│   │   ├── widgets/
│   │   │   └── profile_item_tile.dart      # Profile & KYC document row
│   │   └── delivery_profile_screen.dart    # Rider profile, vehicle & KYC tab
│   └── navigation/
│       └── delivery_main_navigation_screen.dart # 4-tab IndexedStack navigation
└── widgets/
    ├── delivery_app_bar.dart               # Fleet header with online/offline toggle & notifications
    ├── delivery_bottom_bar.dart            # Material 3 NavigationBar
    └── notifications_modal.dart            # Notifications bottom sheet
```

## Getting Started

1. Get dependencies:
   ```bash
   flutter pub get
   ```

2. Run code analysis:
   ```bash
   flutter analyze
   ```

3. Launch app:
   ```bash
   flutter run
   ```
