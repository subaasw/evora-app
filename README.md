# Evora

Event management and auditorium ticketing app, built with Flutter. A polished,
navigable UI prototype backed by in-memory mock data — no backend required.

It covers the three actors of an Event Management System:

- **Attendee** — browse events, pick tickets and seats, apply promo codes, pay,
  get a QR ticket, and join waitlists for sold-out events.
- **Organizer** — create and edit events, set ticket types, view analytics, and
  scan attendee QR codes to check people in.
- **Admin** — register organizers and view auditorium usage reports.

## Tech stack

- Flutter (Material 3) with a custom hand-drawn design system
- `go_router` for navigation
- `provider` for state (in-memory stores)
- `fl_chart` for analytics, `qr_flutter` for tickets, `mobile_scanner` for check-in
- `google_fonts` for typography

## Getting started

Requires the Flutter SDK (Dart >= 3.12).

```bash
flutter pub get
flutter run
```

Targets: Android and Web.

```bash
flutter run -d chrome      # web
flutter build apk          # android release
flutter build web          # web release
```

### Demo logins

Authentication is mocked — any input works.

- **Attendee:** sign in on the main screen.
- **Organizer / Admin:** tap *"Organizer or Admin? Staff sign in"* on the login
  screen, then pick a role.

To see check-in succeed: book a ticket as an attendee, then open the organizer
**Check-in** tab and scan that ticket's QR (or use *Simulate scan*).

## Testing

```bash
flutter test
```

## Project structure

```
lib/
  main.dart            # entrypoint + providers
  router.dart          # go_router routes and transitions
  theme/               # colors, tokens, theme, shadows
  data/
    app_role.dart
    mock/              # models + ChangeNotifier stores + seed data
  widgets/             # shared UI (sketch components, charts, QR, ...)
  features/
    auth/              # splash, login, signup, staff login
    attendee/          # browse, booking flow, tickets, waitlist
    organizer/         # events, create/edit, analytics, check-in
    admin/             # organizers, register, reports
test/                  # unit tests for booking + stores
```

## App icons

Launcher icons are generated from `assets/icon/` via `flutter_launcher_icons`:

```bash
dart run flutter_launcher_icons
```

## Notes

This is a UI prototype: data lives in memory and resets on restart. Payments,
emails, PDF export, and real authentication are intentionally mocked.
