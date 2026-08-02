# Pantau

Mobile app for reporting and tracking local civic infrastructure problems — potholes, broken streetlights, overflowing trash, clogged drains, damaged signage. Resident photographs issue, app captures location, categorises and submits. Report shows on public map, status moves `reported → acknowledged → in_progress → resolved / rejected → closed` with visible history at each step.

Full requirements: [`docs/Pantau_PRD_v2.md`](docs/Pantau_PRD_v2.md).

## Stack

- Flutter, Riverpod (`flutter_riverpod` + `riverpod_generator`) for state
- `go_router` for navigation
- `dio` for networking, `drift` for local DB, `flutter_secure_storage` for secure storage
- `flutter_map` + `latlong2` for map/geolocation
- `freezed` / `dart_mappable` for models, `fpdart` for functional error handling

## Architecture

Feature-first, Clean Architecture per feature:

```
lib/
  core/           # shared: components, DI, network, router, theme, utils
  features/
    <feature>/
      data/
      di/
      domain/
      presentation/
```

Current features: `auth`, `category`, `dashboard`, `map`, `my_reports`, `notification`, `onboarding`, `profile`, `report`, `resolver`.

New features scaffold via Mason (`bricks/features`, see `mason.yaml`).

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
