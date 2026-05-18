# KAKW DEPOT

A Flutter mobile app for warehouse order management with Firebase backend.

## Customer features

- Login / signup
- Place orders
- View previous orders

## Admin features

- View all orders
- Update dispatch status
- Export Excel report

## Technology stack

- Flutter
- Firebase (Auth + Firestore)
- Excel export support

## Project structure

- `android/` — Android platform project scaffold
- `lib/main.dart` — app entry point
- `lib/app.dart` — theme and authentication routing
- `lib/services/` — authentication and order services
- `lib/screens/` — login, customer dashboard, admin dashboard
- `lib/models/` — order data model
- `lib/widgets/` — reusable order card UI

## Setup

1. Install Flutter on your machine: https://flutter.dev/docs/get-started/install
2. Add Firebase to the app using the FlutterFire CLI and generate platform configuration files.
3. Place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`.
4. Create `android/local.properties` with your Flutter SDK path, for example:
   ```properties
   flutter.sdk=/path/to/flutter
   ```
5. Run:
   ```bash
   flutter pub get
   flutter run
   ```

## Firebase configuration

- Enable Email/Password authentication in Firebase Auth.
- Create a Firestore collection named `orders`.
- The app writes orders with fields: `itemName`, `quantity`, `customerName`, `status`, `createdBy`, `createdAt`.
- Admin users are identified by email in `lib/utils/constants.dart`. Update the `adminEmails` list as needed.

## Notes

- This repository contains the Flutter app scaffold and core logic.
- Firebase configuration files are required for the app to initialize.
- Excel export uses a temporary file path and can be extended to share or download the exported report.
