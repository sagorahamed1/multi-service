# AutoRevive

AutoRevive is a Flutter-based mobile application that connects customers with nearby mechanics and tow truck providers for on-demand roadside assistance and vehicle repair services.

## Features

### Authentication & Onboarding
- Role-based registration — Customer, Mechanic, or Tow Truck Provider
- Email verification and OTP-based login
- Password reset and change password flow
- Splash screen and onboarding walkthrough

### Customer Features
- Browse and find nearby mechanics on an interactive map (Google Maps)
- Select vehicle / car before booking a service
- Book a mechanic for on-site repairs
- View booking details and track booking status in real time
- In-app chat with mechanics and tow truck providers
- Push notifications for booking updates
- Payment history and earnings overview
- Edit profile and personal information
- Admin support contact

### Mechanic Features
- Dedicated mechanic home dashboard
- View and manage incoming job requests
- Accept or decline service bookings
- Navigate to customer location via map
- Mark jobs as complete
- Upload resume, certificates, tools, and equipment information
- Set experience, skills, and employment history during profile setup
- View on-site booking details

### Tow Truck Provider Features
- Tow truck home dashboard
- View and manage tow job requests
- Navigate to customer location
- Earning history and payment tracking
- Profile management (personal info, edit profile)

### General Features
- Real-time location tracking with live location updates
- Socket-based real-time communication
- Firebase push notifications (FCM)
- In-app messaging / chat system
- Notifications screen
- Privacy policy screen
- Settings screen
- Offline / no internet detection
- Shimmer loading placeholders

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** GetX
- **Maps:** Google Maps Flutter
- **Backend Communication:** REST API (Dio), Socket.IO
- **Push Notifications:** Firebase Cloud Messaging (FCM)
- **Payments:** Stripe
- **Storage:** SharedPreferences

## Getting Started

### Prerequisites
- Flutter SDK `^3.5.3`
- Android Studio / Xcode
- Firebase project configured

### Run the app

```bash
flutter pub get
flutter run
```

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
