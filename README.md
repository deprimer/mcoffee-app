# MCoffee - Brew Log App

MCoffee is an iOS application built with Kotlin Multiplatform (KMP) for logging coffee brewing details. It allows users to track parameters like coffee name, dose, water amount, brew time, grind setting, method, and more.

## Technologies Used (Current State)

*   **Project Foundation:** Kotlin Multiplatform (KMP) (Shared logic not yet implemented for core features)
*   **iOS Frontend:** SwiftUI
*   **Log Persistence:** `UserDefaults` (within the iOS app)
*   **iOS Project Generation:** XcodeGen
*   **iOS Dependency Management:** CocoaPods

## Build & Run Instructions

1.  **(Optional) Generate KMP Shared Framework (if using shared module):**
    ```bash
    ./gradlew :shared:generateDummyFramework :shared:podspec
    ```
2.  **Generate Xcode Project (Required):**
    ```bash
    xcodegen generate
    ```
3.  **Install Pods (Required):**
    ```bash
    pod install --repo-update
    ```
    *(Note: You might need `arch -x86_64 pod install --repo-update` on Apple Silicon Macs if you encounter pod install issues).*
4.  **Open & Run:** Open `MCoffee.xcworkspace` in Xcode and build/run the `MCoffee` scheme.

## Notes

*   Ensure you have Kotlin, Gradle, XcodeGen, and CocoaPods installed.
*   The project requires Xcode and the iOS SDK.
