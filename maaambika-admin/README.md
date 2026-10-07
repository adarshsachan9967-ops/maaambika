# Maa Ambika Admin App

High-performance, enterprise Flutter administration app for the **Maa Ambika** ecosystem (`in.maaambika.admin`).

## 🏗️ Architecture & Folder Structure

The project follows the exact same clean, modular, BLoC-based structure established in `maaambika-delivery` and `maaambika-partner`:

```text
maaambika-admin/
├── lib/
│   ├── app.dart                                # MaterialApp, theme, global scaffoldMessengerKey
│   ├── main.dart                               # Clean entrypoint with error zone & in-app update checks
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart              # REST endpoints & base URL
│   │   │   ├── app_colors.dart                 # AppColors (Violet, Blue, Slate, Emerald, etc.) & Appcolors typedef
│   │   │   ├── app_constants.dart              # Brand strings, forwarded color constants
│   │   │   └── app_keys.dart                   # Storage & session keys
│   │   ├── services/
│   │   │   ├── api_service.dart                # Dio HTTP client, automatic Bearer auth & retry
│   │   │   ├── in_app_update_service.dart      # Android In-App Updates (Immediate & Flexible)
│   │   │   ├── network_exceptions.dart         # Error message sanitization
│   │   │   ├── session_service.dart            # Local credentials & preferences
│   │   │   └── storage_service.dart            # SharedPreferencesService wrapper
│   │   └── utils/
│   │       ├── currency_formatter.dart         # Indian Rupee (₹) formatting
│   │       ├── helpers.dart                    # URL launchers, snackbars, image url sanitization
│   │       ├── logger.dart                     # Debug logger
│   │       └── session_manager.dart            # Session termination & cleanup
│   ├── data/
│   │   ├── fallback/
│   │   │   └── fallback_admin_data.dart        # Mock datasets for offline / fallback resilience
│   │   └── models/
│   │       ├── admin_order.dart                # Admin order domain model
│   │       ├── audit_activity.dart             # Activity feed audit item model
│   │       ├── overview_metrics.dart           # GMV, order counts, fleet metrics model
│   │       ├── partner_store.dart              # Partner store domain model
│   │       └── promo_coupon.dart               # Coupon & promo code domain model
│   ├── modules/
│   │   ├── navigation/
│   │   │   └── admin_main_navigation_screen.dart # MultiBlocProvider & 5-tab IndexedStack
│   │   ├── overview/
│   │   │   ├── bloc/                           # OverviewBloc, Events, States
│   │   │   ├── models/requests/                # FetchOverviewRequest
│   │   │   ├── models/responses/               # OverviewResponse
│   │   │   ├── repositories/                   # OverviewRepository & OverviewRepositoryImpl
│   │   │   ├── widgets/                        # ExecutiveGmvCard, ActionAlertBanner, HealthCard, ActivityTile
│   │   │   └── admin_overview_screen.dart
│   │   ├── orders/
│   │   │   ├── bloc/                           # AdminOrdersBloc, Events, States
│   │   │   ├── models/requests/                # FetchAdminOrdersRequest, AssignRiderRequest
│   │   │   ├── models/responses/               # AdminOrdersResponse
│   │   │   ├── repositories/                   # AdminOrdersRepository & AdminOrdersRepositoryImpl
│   │   │   ├── widgets/                        # AdminOrderCard
│   │   │   └── admin_orders_screen.dart
│   │   ├── partners/
│   │   │   ├── bloc/                           # PartnersBloc, Events, States
│   │   │   ├── models/requests/                # FetchPartnersRequest, ApproveKycRequest
│   │   │   ├── models/responses/               # PartnersResponse
│   │   │   ├── repositories/                   # PartnersRepository & PartnersRepositoryImpl
│   │   │   ├── widgets/                        # PartnerStoreCard
│   │   │   └── admin_partners_screen.dart
│   │   ├── marketing/
│   │   │   ├── bloc/                           # MarketingBloc, Events, States
│   │   │   ├── models/requests/                # FetchCouponsRequest, SendBroadcastRequest
│   │   │   ├── models/responses/               # CouponsResponse, SendBroadcastResponse
│   │   │   ├── repositories/                   # MarketingRepository & MarketingRepositoryImpl
│   │   │   ├── widgets/                        # BroadcastBannerCard, CouponCard, BroadcastComposerDialog
│   │   │   └── admin_marketing_screen.dart
│   │   └── settings/
│   │       ├── widgets/                        # SettingsItemTile
│   │       └── admin_settings_screen.dart
│   └── widgets/
│       ├── admin_app_bar.dart                  # Header branding & telemetry sync
│       └── admin_bottom_bar.dart               # NavigationBar destinations
```

## 📦 Key Dependencies

- `flutter_bloc: ^9.1.1` - State management (Events, States, Blocs)
- `dio: ^5.11.1` - Networking client with token interceptor and retries
- `shared_preferences: ^2.5.5` - Local key-value storage
- `url_launcher: ^6.3.2` - External phone & map intents
- `in_app_update: ^4.2.5` - Google Play in-app updates
