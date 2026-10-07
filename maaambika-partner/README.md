# Maa Ambika Partner App

Official Merchant & Retail Recommerce Hub for the **Maa Ambika** ecosystem (`in.maaambika.partner`).

## 🏗️ Architecture & Folder Structure

The project follows the exact same clean, modular, BLoC-based structure established in `maaambika-delivery` and `maaambika-admin`:

```text
maaambika-partner/
├── lib/
│   ├── app.dart                                # MaterialApp, theme, global scaffoldMessengerKey
│   ├── main.dart                               # Clean entrypoint with runZonedGuarded & in-app update checks
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart              # Endpoints & base URL
│   │   │   ├── app_colors.dart                 # AppColors & Appcolors typedef
│   │   │   ├── app_constants.dart              # Brand strings & forwarded tokens
│   │   │   └── app_keys.dart                   # Storage & session keys
│   │   ├── services/
│   │   │   ├── api_service.dart                # Dio client, automatic Bearer auth, retry & logging
│   │   │   ├── in_app_update_service.dart      # InAppUpdateService (Immediate & Flexible updates)
│   │   │   ├── network_exceptions.dart         # Dio error sanitization
│   │   │   ├── session_service.dart            # Local credentials & preferences
│   │   │   └── storage_service.dart            # SharedPreferencesService wrapper
│   │   └── utils/
│   │       ├── currency_formatter.dart         # Currency formatting (₹)
│   │       ├── helpers.dart                    # URL launchers, snackbars, image url sanitization
│   │       ├── logger.dart                     # Debug appLog utility
│   │       └── session_manager.dart            # Force logout & token clearing
│   │
│   ├── data/
│   │   ├── fallback/
│   │   │   └── fallback_partner_data.dart      # Mock datasets for offline / fallback resilience
│   │   └── models/
│   │       ├── partner_order.dart              # Partner order model
│   │       ├── partner_stats.dart              # Partner volume & float stats model
│   │       └── store_kyc.dart                  # Store KYC profile model
│   │
│   ├── modules/
│   │   ├── navigation/
│   │   │   └── partner_main_navigation_screen.dart # MultiBlocProvider & 5-tab IndexedStack
│   │   ├── dashboard/
│   │   │   ├── bloc/                           # PartnerDashboardBloc, Events, States
│   │   │   ├── models/
│   │   │   │   ├── requests/fetch_dashboard_request.dart
│   │   │   │   └── responses/dashboard_response.dart
│   │   │   ├── repositories/                   # DashboardRepository & DashboardRepositoryImpl
│   │   │   ├── widgets/                        # VolumeMetricCard, QuickActionsRow, QueueCard
│   │   │   └── partner_dashboard_screen.dart
│   │   ├── orders/
│   │   │   ├── bloc/                           # PartnerOrdersBloc, Events, States
│   │   │   ├── models/
│   │   │   │   ├── requests/fetch_partner_orders_request.dart
│   │   │   │   └── responses/partner_orders_response.dart
│   │   │   ├── repositories/                   # PartnerOrdersRepository & PartnerOrdersRepositoryImpl
│   │   │   ├── widgets/                        # OrderTile
│   │   │   └── partner_orders_screen.dart
│   │   ├── inspection/
│   │   │   ├── bloc/                           # PartnerInspectionBloc, Events, States
│   │   │   ├── models/
│   │   │   │   ├── requests/submit_inspection_request.dart
│   │   │   │   └── responses/inspection_response.dart
│   │   │   ├── repositories/                   # InspectionRepository & InspectionRepositoryImpl
│   │   │   └── partner_inspection_screen.dart
│   │   ├── payouts/
│   │   │   ├── bloc/                           # PartnerPayoutsBloc, Events, States
│   │   │   ├── models/
│   │   │   │   ├── requests/instant_payout_request.dart
│   │   │   │   └── responses/payout_response.dart
│   │   │   ├── repositories/                   # PayoutsRepository & PayoutsRepositoryImpl
│   │   │   └── partner_payouts_screen.dart
│   │   └── profile/
│   │       ├── bloc/                           # PartnerProfileBloc, Events, States
│   │       ├── models/
│   │       │   ├── requests/update_profile_request.dart
│   │       │   └── responses/partner_profile_response.dart
│   │       ├── repositories/                   # PartnerProfileRepository & PartnerProfileRepositoryImpl
│   │       ├── widgets/                        # ProfileItemTile
│   │       └── partner_profile_screen.dart
│   │
│   └── widgets/
│       ├── partner_app_bar.dart                # Header branding & tier display
│       ├── partner_bottom_bar.dart             # NavigationBar destinations
│       └── notifications_modal.dart            # In-app notifications bottom sheet
```

## 📦 Key Dependencies

- `flutter_bloc: ^9.1.1` - State management (Events, States, Blocs)
- `dio: ^5.11.1` - Networking client with token interceptor and retries
- `shared_preferences: ^2.5.5` - Local key-value storage
- `url_launcher: ^6.3.2` - External phone & map intents
- `in_app_update: ^4.2.5` - Google Play in-app updates
