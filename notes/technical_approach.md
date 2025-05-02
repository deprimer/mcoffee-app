# Technical Approach: Personal Coffee Logger (iOS with Kotlin Multiplatform)

## 1. Introduction

This document outlines a recommended technical approach for developing the Personal Coffee Logger application for iOS, as specified in the Product Requirements Document (PRD). The core requirements include building an iOS-native application primarily using Kotlin, leveraging Kotlin Multiplatform (KMP) for shared logic, and strictly adhering to Apple's Human Interface Guidelines (HIG) for the user interface and experience.

## 2. Kotlin Multiplatform (KMP) Architecture

Kotlin Multiplatform is the chosen technology to maximize code sharing while delivering a native iOS experience. The project structure will typically involve:

*   **Shared Module:** Contains the common Kotlin code, including business logic, data models, data access layers, and potentially shared view models. This module targets common Kotlin (`commonMain`) and platform-specific source sets (`iosMain`, potentially `androidMain` if future expansion is considered).
*   **iOS Application Module:** An Xcode project that includes the native iOS UI code (Swift/SwiftUI) and depends on the shared KMP module. It utilizes the shared logic and provides platform-specific implementations where necessary.

Build configuration will be managed using Gradle with the Kotlin Multiplatform plugin, handling dependencies and the compilation process for both shared and native parts.

## 3. Shared Logic Module (`commonMain`)

The majority of the application's non-UI logic will reside here:

*   **Data Models:** Define `data class`es in Kotlin for `BrewLog` and related entities (e.g., `BrewMethod`, `RoastLevel` enums) as outlined in the PRD. Use Kotlinx Serialization for potential data serialization needs.
*   **Business Logic:** Implement the core functionalities like saving/retrieving logs and the logic for generating grind setting suggestions based on historical data and ratings. Kotlin Coroutines should be used for handling asynchronous operations like database access.
*   **Repository Pattern:** Abstract data access behind interfaces (repositories) defined in `commonMain`. This allows different data storage implementations for different platforms if needed, although for this project, a KMP-compatible database is preferred.
*   **ViewModel/Presenter Layer (Optional but Recommended):** Utilize KMP libraries like `KMMViewModel` or architectural patterns like MVI (e.g., using `MVIKotlin`) to create shared ViewModels or Presenters. These components prepare data for the UI and handle UI events, further reducing the amount of platform-specific UI logic.

## 4. iOS Application Module & UI (SwiftUI)

The iOS module bridges the shared Kotlin logic with the native iOS platform.

*   **UI Implementation (SwiftUI):** SwiftUI is strongly recommended for building the user interface. It aligns naturally with Apple's HIG, facilitates declarative UI development, and integrates well with modern Swift practices. Standard SwiftUI components (Forms, Lists, NavigationStack, TextFields, Pickers, Steppers, etc.) should be used to ensure a native look and feel.
*   **Connecting UI to Shared Logic:** The SwiftUI views will observe and interact with the shared ViewModels/Presenters created in the KMP module. Libraries like `KMP-NativeCoroutines` can simplify the use of Kotlin Coroutines and Flows within the Swift environment.
*   **Platform-Specific APIs:** If any features require direct access to iOS-specific APIs not easily abstracted in KMP (e.g., specific HealthKit integrations if added later, advanced background processing), these would be implemented in Swift within the iOS module, potentially using the `expect`/`actual` mechanism of KMP for cleaner integration if needed.

## 5. Data Persistence

Reliable local storage is crucial for persisting brew logs on the device. Given the KMP context, several options exist:

*   **SQLDelight:** Recommended approach. It generates type-safe Kotlin APIs from SQL statements, works seamlessly across platforms supported by KMP (including native iOS), and uses the native SQLite engine on each platform. This provides a robust and efficient way to manage structured data.
*   **Realm KMP:** Another viable option, offering an object-oriented database approach that supports KMP. It might offer simpler object persistence but adds a larger dependency.
*   **CoreData (via Interop):** While possible to access CoreData from shared Kotlin code using `expect`/`actual` declarations, it adds complexity compared to using a KMP-first database solution like SQLDelight. It's generally less recommended unless there's a strong reason to use CoreData specifically.

The chosen solution should handle database setup, migrations (if the schema evolves), and provide implementations for the data access interfaces defined in the shared module's repository layer.

## 6. UI/UX & HIG Alignment

Adherence to Apple's HIG is paramount and should guide all UI/UX decisions:

*   **Standard Controls:** Use native SwiftUI controls for all interactions.
*   **Navigation:** Employ standard iOS navigation patterns (e.g., `NavigationStack` for hierarchical views, TabViews if appropriate).
*   **Layout:** Respect safe areas, use adaptive layouts for different screen sizes (though primarily targeting iPhone), and support Dynamic Type for accessibility.
*   **Appearance:** Support both Light and Dark Modes.
*   **Clarity & Efficiency:** Ensure the log entry form is intuitive, distinguishing mandatory vs. optional fields clearly. Make viewing history effortless.
*   **Feedback & Responsiveness:** Provide clear visual feedback for actions and ensure the UI remains responsive.

## 7. Suggestion Engine Logic

The logic for suggesting grind settings should be implemented within the shared Kotlin module. It would likely involve:

1.  Querying the database (via the repository) for past `BrewLog` entries, filtering by relevant parameters (e.g., coffee type, brew method).
2.  Analyzing the relationship between `grindSetting` and `tasteRating` in the filtered results.
3.  Applying a simple algorithm (e.g., if the last similar brew was rated poorly, suggest adjusting the grind slightly finer or coarser based on common coffee knowledge or patterns in the user's own data) to generate a suggestion.
4.  Presenting this suggestion clearly to the user via the ViewModel/Presenter layer.

## 8. Key Dependencies & Libraries

*   Kotlin Multiplatform Gradle Plugin
*   Kotlin Coroutines (`kotlinx-coroutines-core`)
*   Kotlin Serialization (`kotlinx-serialization-json`)
*   SQLDelight (Runtime & Coroutines extensions, Gradle Plugin, Native Driver)
*   KMP-NativeCoroutines (for Swift interop)
*   KMMViewModel or MVIKotlin (optional, for shared ViewModel/State Management)

## 9. Development Workflow

Development can primarily occur in IntelliJ IDEA or Android Studio using the Kotlin Multiplatform Mobile plugin. Building and running the iOS application will typically be done through Xcode, which integrates with the KMP build process managed by Gradle.

This technical approach provides a solid foundation for building the Personal Coffee Logger app using Kotlin Multiplatform while ensuring a high-quality, native iOS experience.
