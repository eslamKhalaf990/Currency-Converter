# Currency Converter

A professional-grade Currency Converter mobile application built with Flutter.

## 1. Project Overview & Setup Instructions

This repository contains the foundation of a robust Currency Converter application. Currently, the core architecture, data layer, domain logic, and networking are fully implemented, while the presentation (UI) layer is actively being developed.

### Usage Instructions
To get this project up and running locally, ensure you have Flutter installed, then run the following commands:
```bash
git clone https://github.com/eslamKhalaf990/Currency-Converter.git
cd currency_converter
flutter pub get
flutter run
```
*Note: As the UI is a work-in-progress, running the app currently displays an initialization placeholder.*

**Zero Configuration Requirement**
This application utilizes the v2 **Frankfurter API** (`https://api.frankfurter.app`), which is entirely free, open-source, and explicitly requires **NO API keys**. Because of this, developers can immediately run the app on a clean clone without configuring any `.env` files or environment variables.

## 2. Architectural Decisions (The "Why")

In designing and building this application, several engineering decisions were made to prioritize scalability, maintainability, and reliability. **These are fully implemented in the current codebase:**

- **Clean Architecture:** 
  The codebase strictly adheres to Clean Architecture principles, properly delineated into `Domain`, `Data`, and `Presentation` layers. This separation strictly enforces inward dependencies, keeping business logic agnostic of UI or data frameworks.
  
- **Functional Error Handling:** 
  To guarantee stability, `dartz` (`Either<Failure, Success>`) is implemented at the repository boundaries (`BaseRepository`). This ensures that raw network or cache exceptions are caught at the source, mapped into domain-specific failures, and importantly, never leak directly into the core business logic.

- **Data Types for Currency:** 
  Explicit steps were taken to prevent standard floating-point precision errors usually associated with `double`. Monetary exchange rates are optimally handled through the usage of precision-safe `Decimal` types in our models.
  
- **Multithreading & Offline Fallback:** 
  The app fetches data using the `/latest?base={currency}` endpoint. Because JSON parsing can cause UI stutter, Dart's `compute()` function is utilized in `RemoteDataSource` & `LocalDataSource` to handle all processing off the main thread. Responses are aggressively cached using **Hive**, providing an incredibly robust offline fallback if the network drops.

## 3. Presentation Layer & UI (Work In Progress)

The UI layer is currently in the scaffolding phase. The planned design system and presentation architecture will include:

- **State Management:** 
  Using `flutter_bloc` integrated with **Dart 3 sealed classes** to manage application state constraints (`Initial`, `Loading`, `Success`, `Error`), ensuring the UI gracefully accounts for every possible state.
- **Systematic Structure & Widgets:** 
  A centralized, clean, and minimalist design system utilizing strict structural tokens and bespoke extracted components (e.g., `AppTextField`, `AppButton`).
- **Responsiveness & Dark Mode:** 
  Strategic uses of `LayoutBuilder` implementations to constrain forms nicely for tablets, alongside automatic full Dark Mode support.

## 4. AI Policy & Usage Note

*This project leveraged AI assistance as a focused pair-programming tool, accelerating standard development workflows.*

Specifically, Large Language Models (AI assistants like Claude/Antigravity) were utilized to:
- Scaffold rigid boilerplate layouts and directory structures.
- Generate repetitive and predictable data models, namely configuring `fromJson`/`toJson` mechanisms.
- Draft initial test setups and structural unit tests.

**Engineering Ownership:**
It is critical to note that the core architectural boundaries, dependency injection mappings, domain error mapping rules, caching workflows, and high-level component structures were strictly human-directed. Every line of generated code was manually verified and iterated upon by the engineer for production-ready quality.
