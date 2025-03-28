# Supabase Integration for Eli

This document provides an overview of the Supabase integration in the Eli Flutter application.

## Setup

### 1. Environment Variables

For web development, you need to pass the Supabase credentials as environment variables during app initialization:

```bash
flutter run --web-renderer html --dart-define=SUPABASE_URL=your_supabase_url --dart-define=SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 2. Code Generation

The project uses code generation for Riverpod providers and Freezed models. After making changes to files with the `@riverpod` or `@freezed` annotations, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Features

### Authentication

The authentication system is set up with the following features:
- Email/password sign-up
- Email/password login
- Session persistence
- Auth state monitoring

### State Management

The app uses Riverpod for state management with the following components:
- Code-generated providers using `@riverpod` annotations
- State notifiers for complex state
- Freezed models for immutable data objects

### Routing

The app uses go_router for navigation, with:
- Route protection based on authentication state
- Named routes
- Declarative routing configuration

## Project Structure

```
lib/
  ├── config/               # Configuration files
  ├── core/                 # Core app functionality
  │   └── providers/        # Core providers
  └── features/             # Feature modules
      ├── auth/             # Authentication feature
      │   ├── models/       # Auth-related models
      │   ├── providers/    # Auth-related providers
      │   └── screens/      # Auth UI screens
      └── home/             # Home feature
          └── screens/      # Home UI screens
```

## Next Steps

1. Customize the UI to match your application's design
2. Add additional Supabase features such as database access or storage
3. Implement more advanced authentication flows if needed
4. Add error handling and loading states to improve user experience