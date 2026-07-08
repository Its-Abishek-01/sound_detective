# Sound Detective

Sound Detective is a Flutter app that helps you identify what caused a sound you just heard on your phone.

It watches recent Android system signals, stores them locally, and uses a scoring engine to guess the most likely source of a sound within the last 30 seconds. The app also keeps a history of past detections and a timeline of collected device events.

## What It Does

- Collects native Android events in the background
- Correlates notifications, media playback, Bluetooth, USB, audio focus, foreground app state, and device state
- Analyzes the most recent 30 seconds when you tap the main action button
- Shows a likely source, confidence score, and explanation for the result
- Saves previous detections and raw event activity locally for review
- Supports a Quick Settings tile for fast analysis launches on Android

## How It Works

1. Native collectors in Android observe system activity and push events into a shared event stream.
2. Flutter ingests those events and stores them in a local Drift database.
3. When analysis runs, the app reconstructs any missing foreground-app context, pulls the last 30 seconds of events, and adds the current ringer mode as extra context.
4. The Dart scoring engine ranks possible sources using a set of rules.
5. The UI presents the most likely cause, or `Unknown` when confidence is too low.

## Main Screens

- `Onboarding`: walks through the permissions required for background detection
- `Detective`: the main screen with the large "I JUST HEARD A SOUND" action
- `History`: past analysis results, newest first
- `Timeline`: chronological view of recorded device events

## Permissions

On first launch, the app asks for:

- Notification access
- Usage access
- Bluetooth permission

These are required for the core experience.

It also offers:

- Battery optimization exemption

This is optional, but recommended for more reliable background listening.

## Platform Notes

The full detection experience is Android-first because it depends on Android services, notification listeners, usage stats, and the Quick Settings tile.

The repository also contains Flutter desktop and web scaffolding, but the core sound-detection workflow is built around the Android implementation.

## Project Structure

- `lib/main.dart`: app entry point
- `lib/app`: app shell and dependency wiring
- `lib/features`: UI flows for onboarding, detective mode, history, and timeline
- `lib/domain/scoring`: pure Dart scoring rules and result models
- `lib/data`: local models, database, and repositories
- `lib/platform`: Flutter bridge to Android channels
- `android/app/src/main/kotlin`: native collectors, services, and channel handlers

## Tech Stack

- Flutter
- Riverpod
- Drift
- Android native services and platform channels

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android toolchain set up
- An Android device or emulator for the full feature set

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

For Android, grant the requested permissions when prompted so the app can listen in the background.

## Testing

Run the test suite with:

```bash
flutter test
```

## Detection Window

The app analyzes the last 30 seconds of collected events. If nothing in that window is strong enough to explain the sound, the result is shown as `Unknown` instead of forcing a guess.

## Troubleshooting

- If the app says background listening is not active, make sure the required permissions are granted.
- If the app keeps returning `Unknown`, try again after a more distinctive event, such as a notification, media start, Bluetooth connect, or USB change.
- If the app was launched from the Quick Settings tile, the main screen should auto-run analysis once the app is ready.

## License

Add your preferred license here if you plan to publish or share the project.
