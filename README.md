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

## 2. Engineering Code Audits & Refactoring Insights

A core philosophy of this project is continuous, meticulous auditing of every line of code rather than accepting initial drafts or "good enough" implementations. Recent deliberate refactoring rounds highlight this standard:

- **Strict BaseRepository Enforcement (Higher-Order Functions):** 
  Upon reviewing the initial completion of the data layer, it was noted that boilerplate try-catch blocks and error handling were scattered. To enforce a truly sterile architecture, the `CurrencyRepositoryImpl` was deliberately refactored aggressively to depend on a newly created `BaseRepository`. By passing higher-order functions into a unified boundary pipeline, redundant logic was eliminated, and all remote calls/exceptions are mapped functionally without boilerplate.
  
- **Fintech Standards (Migrating Away from Doubles):** 
  During a meticulous sweep of the data models and entity structures, the usage of standard primitive `double` types for monetary amounts was identified. Acknowledging that primitive floating-point arithmetic inherently produces precision loss, a deliberate architectural migration was executed to replace all `double` references with precision-safe `Decimal` types across all layers. This guarantees banking-grade arithmetic consistency.

- **Main Thread Preservation (Isolates & Compute):** 
  While analyzing the data flow, it was recognized that mapping large lists of deeply nested JSON from the exchange rates API could block the main UI thread during network responses, leading to dropped frames (UI stutter). Consequently, a conscious architectural decision was made to abstract all JSON parsing in both `LocalDataSource` and `RemoteDataSource` into Dart background isolates using `compute()`, ensuring a fluid 60FPS user experience even with massive payloads.

## 3. High-Level Architectural Decisions (The "Why")

In designing and building this application, several engineering decisions were made to prioritize scalability, maintainability, and reliability:

- **Clean Architecture:** 
  The codebase strictly adheres to Clean Architecture principles, properly delineated into `Domain`, `Data`, and `Presentation` layers. This separation strictly enforces inward dependencies, keeping business logic agnostic of UI or data frameworks.
  
- **Functional Error Handling:** 
  To guarantee stability, `dartz` (`Either<Failure, Success>`) is implemented at the repository boundaries (`BaseRepository`). This ensures that raw network or cache exceptions are caught at the source, mapped into domain-specific failures, and importantly, never leak directly into the core business logic.
  
- **Network Resilience & Offline Fallback:** 
  The app aggressively caches network responses natively using **Hive**, providing an incredibly robust offline fallback if the network drops and ensuring zero service disruption.

## 4. Presentation Layer & UI (Work In Progress)

The UI layer is currently in the scaffolding phase. The planned design system and presentation architecture will include:

- **State Management:** 
  Using `flutter_bloc` integrated with **Dart 3 sealed classes** to manage application state constraints (`Initial`, `Loading`, `Success`, `Error`), ensuring the UI gracefully accounts for every possible state.
- **Systematic Structure & Widgets:** 
  A centralized, clean, and minimalist design system utilizing strict structural tokens and bespoke extracted components (e.g., `AppTextField`, `AppButton`).
- **Responsiveness & Dark Mode:** 
  Strategic uses of `LayoutBuilder` implementations to constrain forms nicely for tablets, alongside automatic full Dark Mode support.

## 5. AI Policy & Usage Note

*This project leveraged AI assistance as a focused pair-programming tool, accelerating standard development workflows.*

Specifically, Large Language Models (AI assistants like Claude/Antigravity) were utilized to:
- Scaffold rigid boilerplate layouts and directory structures.
- Generate repetitive and predictable data models, namely configuring `fromJson`/`toJson` mechanisms.
- Draft initial test setups and structural unit tests.

**Engineering Ownership:**
It is critical to note that the core architectural boundaries, dependency injection mappings, domain error mapping rules, caching workflows, and high-level component structures were strictly human-directed. Every line of generated code was manually verified and iterated upon by the engineer for production-ready quality.
