# MCoffee - Brew Log App

MCoffee is an iOS application built with Kotlin Multiplatform (KMP) for logging coffee brewing details. It allows users to track parameters like coffee name, dose, water amount, brew time, grind setting, method, and more.

## Technologies Used

*   **Shared Logic:** Kotlin Multiplatform (KMP)
*   **iOS Frontend:** SwiftUI
*   **Database:** SQLDelight
*   **iOS Project Generation:** XcodeGen
*   **iOS Dependency Management:** CocoaPods

## Build & Run Instructions

1.  **Generate Shared Framework:**
    ```bash
    ./gradlew :shared:generateDummyFramework :shared:podspec
    ```
2.  **Generate Xcode Project:**
    ```bash
    xcodegen generate
    ```
3.  **Install Pods:**
    ```bash
    pod install --repo-update
    ```
    *(Note: You might need `arch -x86_64 pod install --repo-update` on Apple Silicon Macs if you encounter pod install issues).*
4.  **Open Xcode:**
    Open the generated `MCoffee.xcworkspace` file in Xcode.
5.  **Build & Run:**
    Select the `MCoffee` scheme and run on a simulator or a connected device.

## Notes

*   Ensure you have Kotlin, Gradle, XcodeGen, and CocoaPods installed.
*   The project requires Xcode and the iOS SDK.
