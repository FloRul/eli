# ELI - Project Guidelines

## Build & Test Commands
- Build: `flutter build`
- Run: `flutter run`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Test (all): `flutter test`
- Test (single): `flutter test test/widget_test.dart`
- Clean: `flutter clean`
- Pub Get: `flutter pub get`

## Code Style Guidelines
- Dart with strong typing
- Follow Flutter lint rules (flutter_lints package)
- Imports: group and sort (dart, flutter, external, internal)
- Naming: camelCase for variables/functions, PascalCase for classes/widgets
- Error handling: use try/catch with specific error types
- Comments: explain "why" not "what"
- Prefer async/await over Futures.then()
- Use Material Design patterns for UI components
- Avoid dynamic type, use proper typing
- Use stateless widgets where possible

This document will be automatically loaded into Claude's context when working in this repository.