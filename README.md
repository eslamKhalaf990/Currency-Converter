# Currency Converter

A professional-grade Currency Converter mobile application built with Flutter.

## 1. Project Overview & Setup Instructions

This is a robust and responsive Currency Converter application built with Flutter. It dynamically fetches live exchange rates, allows seamless conversion between different currencies, and functions beautifully across multiple screen sizes.

### Usage Instructions
To get this project up and running locally, ensure you have Flutter installed, then run the following commands:
```bash
git clone https://github.com/eslamKhalaf990/Currency-Converter.git
cd currency_converter
flutter pub get
flutter run
```

**Zero Configuration Requirement**
This application utilizes the v2 **Frankfurter API** ([https://api.frankfurter.dev](https://api.frankfurter.dev)), which is entirely free, open-source, and explicitly requires **NO API keys**. Because of this, reviewers can immediately run the app on a clean clone without configuring any `.env` files or environment variables.

## 2. Architectural Decisions (The "Why")

In designing and building this application, several engineering decisions were made to prioritize scalability, maintainability, and reliability:

- **Clean Architecture:** 
  The codebase strictly adheres to Clean Architecture principles, properly delineated into `Domain`, `Data`, and `Presentation` layers. This separation strictly enforces inward dependencies, keeping business logic agnostic of UI or data frameworks.
  
- **State Management:** 
  We use `flutter_bloc` integrated with **Dart 3 sealed classes** to manage application state. By leveraging sealed classes, we achieve exhaustive pattern matching (`Initial`, `Loading`, `Success`, `Error`), thereby ensuring the UI gracefully accounts for every possible state and preventing unhandled runtime UI bugs.
  
- **Functional Error Handling:** 
  To guarantee stability, `dartz` (`Either<Failure, Success>`) is implemented at the repository boundaries. This ensures that raw exceptions are caught at the source, mapped into domain-specific failures, and importantly, never leak directly into the core business logic or presentation state.

- **Data Types for Currency:** 
  Explicit steps were taken to prevent standard floating-point precision errors usually associated with `double`. Monetary amounts are optimally handled either by converting to minor units/cents or through the usage of precision-safe `Decimal` types.
  
- **Multithreading & Offline Fallback:** 
  The app fetches data using the `GET /v2/rates?base={currency}` endpoint. Because JSON parsing can be expensive and cause UI stutter on large payloads, Dart's `compute()` function is used to handle all array parsing off the main thread, maintaining fluid 60fps animations. This payload is subsequently aggressively cached using **Hive**, providing an incredibly robust offline fallback if the network drops.

## 3. Design System & UI Approach

- **Systematic Structure:** 
  A centralized, clean, and minimalist design system oversees the presentation layer. It utilizes strict structural tokens for overarching constraints (standardized colors, typography scales, spacing tokens).

- **Reusable Widget Library:** 
  To enforce visual consistency and improve UI iteration speed, base components are extracted into a bespoke widget library (e.g., `AppTextField`, `AppButton`, `AppSnackbar`).

- **Responsiveness & Dark Mode:** 
  By strategically using `LayoutBuilder` implementations, the application sets maximum width constraints on forms. This means whether you are using a mobile phone or scaling up to a tablet environment, the input forms sit cleanly on-screen without stretching unnecessarily. Full Dark Mode support is automatically derived from the device theme.

## 4. AI Policy & Usage Note

*This project leveraged AI assistance as a focused pair-programming tool, accelerating standard development workflows.*

Specifically, Large Language Models (AI assistants like Claude/Antigravity) were utilized to:
- Scaffold rigid boilerplate layouts.
- Generate repetitive and predictable data models, namely configuring `fromJson`/`toJson` mechanisms.
- Draft initial test setups and structural tests.

**Engineering Ownership:**
It is critical to note that the core architectural boundaries, dependency injection mappings, domain error mapping rules, state management workflows, and high-level component structures were strictly human-directed. Every line of generated code was manually verified and iterated upon by the engineer for production-ready quality.
