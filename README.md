# Currency Converter

A professional-grade Currency Converter mobile application built with Flutter.

## 1. Project Overview & Setup Instructions

This repository contains the foundation of a robust Currency Converter application. The core architecture, data layer, domain logic, networking, and the responsive presentation (UI) layer are fully implemented and integrated.

### Usage Instructions
To get this project up and running locally, ensure you have Flutter installed, then run the following commands:
```bash
git clone https://github.com/eslamKhalaf990/Currency-Converter.git
cd currency_converter
flutter pub get
flutter run
```

**Zero Configuration Requirement**
This application utilizes the v2 **Frankfurter API** (`https://api.frankfurter.app`), which is entirely free, open-source, and explicitly requires **NO API keys**. Because of this, developers can immediately run the app on a clean clone without configuring any `.env` files or environment variables.

## 2. Engineering Code Audits & Refactoring Insights

A core philosophy of this project is continuous, meticulous auditing of every line of code rather than accepting initial drafts or "good enough" implementations. Recent deliberate refactoring rounds highlight this standard:

- **Strict BaseRepository Enforcement (Higher-Order Functions):** 
  Upon reviewing the initial completion of the data layer, it was noted that boilerplate try-catch blocks and error handling were scattered. To enforce a truly sterile architecture, the repositories were deliberately refactored aggressively to depend on a newly created `BaseRepository`. By passing higher-order functions into a unified boundary pipeline, redundant logic was eliminated, and all remote calls/exceptions are mapped functionally without boilerplate.
  
- **Architecture Modularization (Feature Separation):**
  As the codebase grew, a structural bottleneck was identified in a monolithic `currency_converter` feature directory. To enhance scalability and maintainability, the project was restructured into distinct feature modules (`converter`, `history`, and `core`). This ensured stricter separation of concerns, decoupling the local conversion logs from the core fetching domain.
  
- **Fintech Standards (Migrating Away from Doubles):** 
  During a meticulous sweep of the data models and entity structures, the usage of standard primitive `double` types for monetary amounts was identified. Acknowledging that primitive floating-point arithmetic inherently produces precision loss, a deliberate architectural migration was executed to replace all `double` references with precision-safe `Decimal` types across all layers. This guarantees banking-grade arithmetic consistency.

- **Production-Secure Networking (Dio Logging):** 
  A critical audit of the networking stack revealed HTTP request and response logging (`LogInterceptor`) was unconditionally enabled. To secure the application aligning with enterprise best practices, the Dio instantiation was refactored to conditionally inject the `LogInterceptor` exclusively during `kDebugMode`. This absolutely prevents sensitive data, payloads, or headers from leaking into production console logs, while a new dedicated `ErrorInterceptor` handles clean functional error mappings.

- **Main Thread Preservation (Isolates & Compute):** 
  While analyzing the data flow, it was recognized that mapping large lists of deeply nested JSON from the exchange rates API could block the main UI thread during network responses, leading to dropped frames (UI stutter). Consequently, a conscious architectural decision was made to abstract all JSON parsing in both `LocalDataSource` and `RemoteDataSource` into Dart background isolates using `compute()`, ensuring a fluid 60FPS user experience even with massive payloads.

## 3. High-Level Architectural Decisions (The "Why")

In designing and building this application, several engineering decisions were made to prioritize scalability, maintainability, and reliability:

- **Clean Architecture:** 
  The codebase strictly adheres to Clean Architecture principles, properly delineated into `Domain`, `Data`, and `Presentation` layers per feature. This separation strictly enforces inward dependencies, keeping business logic agnostic of UI or data frameworks.
  
- **Functional Error Handling:** 
  To guarantee stability, `dartz` (`Either<Failure, Success>`) is implemented at the repository boundaries (`BaseRepository`). This ensures that raw network or cache exceptions are caught at the source, mapped into domain-specific failures, and importantly, never leak directly into the core business logic.
  
- **Network Resilience & Offline Fallback:** 
  The app aggressively caches network responses natively using **Hive**, providing an incredibly robust offline fallback if the network drops and ensuring zero service disruption.

## 4. Presentation Layer & UI

The UI layer combines robust state management with an intuitive, componentized user experience:

- **Systematic Structure & Navigation:** 
  The application utilizes a `BottomNavigationBar` to seamlessly route users between active features like the Live Converter and Conversion History. Complex screens were aggressively componentized into single-responsibility widgets (e.g., `ConversionResultCard`, `CurrencySwapSection`, `AppTextField`).
- **State Management:** 
  Powered by `flutter_bloc` integrated with **Dart 3 sealed classes** to manage application state constraints (`Initial`, `Loading`, `Success`, `Error`), ensuring the UI gracefully accounts for every possible state and user interaction without throwing unhandled exceptions.
- **Enhanced Interactions:** 
  Integrations such as `currency_picker` offer an elevated and native-feeling selection experience with flag icons and searchable lists, paired with automatic full Dark Mode support and responsive constraints (`LayoutBuilder`).

## 5. AI Policy & Usage Note

*This project heavily leveraged AI assistance as a highly integrated development partner and technical planner, significantly accelerating standard software engineering workflows.*

**Task Planning & Engineering Setup with Claude Code:**
I extensively utilized **Claude Code** (an agentic CLI tool) to manage the bulk of the engineering setup. Before writing a single line of code, Claude Code was instructed to break down the technical assessment into manageable, bite-sized tasks. It acted as an engineering staff partner by preparing a comprehensive, step-by-step roadmap detailing exactly where to start and dynamically adapting plans as architecture shifted.

**Recent AI-Assisted Updates & Observations:**
- **Architectural Restructuring Scripts:** Migrating from a monolithic structure to granular feature modules (`converter` and `history`) entailed moving dozens of interconnected files. AI was invaluable in writing custom.
- **UI Refinement:** AI tools were highly effective in breaking down monolithic UI classes into smaller, modular widgets, refining spacing/paddings, and seamlessly wiring new dependencies like `currency_picker`.
- **Scaffolding Repetition:** Accelerating predictable tasks, including mapping `fromJson`/`toJson` mechanisms, drafting robust `flutter_bloc` events/states, and generating comprehensive dependency injection setups.

**Engineering Ownership & Insights:**
While AI is phenomenal for scaffolding, structural planning, and batch-refactoring, I noticed that AI models occasionally require meticulous supervision when handling deeply integrated Dependency Injection configurations and strictly enforced domain boundaries. Consequently, all core architectural decisions, absolute boundaries, offline fallback schemas, and precise error handling mechanisms (`Either<Failure, Success>`) were stringently directed, human-reviewed, and tested to ensure they met the project's high standards.
