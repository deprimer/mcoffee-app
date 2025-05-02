# Product Requirements Document: Personal Coffee Logger

## 1. Introduction

This document outlines the requirements for a mobile application designed for personal use, enabling the user to meticulously log their daily coffee brewing process. The primary goal of the application is to serve as a digital journal, capturing key variables involved in brewing coffee, such as bean type, grind settings, water parameters, and brew time. By recording these details along with subjective taste assessments, the user aims to establish a historical baseline of their brewing habits. This baseline will facilitate understanding the impact of different variables on the final taste, allowing the user to reference past results and make informed adjustments to refine their technique and consistently produce better-tasting coffee. The application is intended for the iOS platform and should adhere strictly to Apple's Human Interface Guidelines to ensure a familiar, intuitive, and aesthetically pleasing user experience consistent with the Apple ecosystem. The development will utilize Kotlin, likely leveraging Kotlin Multiplatform (KMP) to potentially share logic while building a native-feeling iOS interface.

## 2. Functional Requirements

### 2.1. Log Entry Creation

The core functionality revolves around the ability to create detailed log entries for each coffee brewing session. When initiating a new log, the user must be prompted to input several essential parameters that form the foundation of the record. These mandatory fields include the specific type or name of the coffee bean or blend being used, the precise weight of the coffee grounds measured in grams, the corresponding weight of the water used for brewing also in grams, and the setting used on the coffee grinder. These four fields are considered critical for basic brew replication and analysis.

In addition to the essential fields, the application should offer the flexibility to capture more granular details, although these will be optional to maintain a quick logging experience if desired. Optional parameters should include the temperature of the water used for brewing (ideally allowing input in Celsius or Fahrenheit), the specific brewing method employed (selectable from a predefined list such as Pour-over, Aeropress, Espresso, French Press, etc., potentially allowing custom entries), the geographical origin of the coffee beans, the roast level of the beans (selectable from options like Light, Medium, Dark), and the total duration of the brew time, likely recorded in minutes and seconds. Furthermore, a crucial component for improvement is capturing the user's subjective assessment of the brew's taste. This should allow for free-text notes to describe the flavor profile, aroma, body, and any other relevant observations, and potentially include a simple rating system (e.g., 1-5 stars or a simple good/bad indicator) to quantify the overall success of the brew.

### 2.2. Log History and Viewing

To make the logged data useful, the application must provide a clear and accessible way to view historical entries. A dedicated section should display a chronological list of all past coffee logs, summarizing key information for quick reference (perhaps date, coffee type, and taste rating). This history view should be easily navigable, potentially offering sorting capabilities (e.g., by date, coffee type, rating) and filtering options to help the user quickly find specific past brews or compare similar ones. Selecting an entry from the history list must navigate the user to a detailed view. This detail screen will display all recorded parameters for that specific brew, including both the essential and any optional fields that were filled in, along with the taste notes and rating.

### 2.3. Brewing Parameter Suggestions

Building upon the logging and history features, the application should incorporate a mechanism to assist the user in improving their coffee. Based on the accumulated data, particularly the relationship between grind settings and taste ratings for similar coffee types and brew methods, the app should offer intelligent suggestions. When preparing to log a new brew, especially if a previous attempt with similar parameters received a less-than-ideal taste rating, the application could propose adjustments. Initially, this could focus on suggesting a slightly finer or coarser grind setting compared to the last recorded brew of the same coffee, guiding the user towards optimizing this critical variable. The logic for these suggestions should be clearly explainable, perhaps noting which previous brews influenced the recommendation.

### 2.4. Data Persistence

All log entries created by the user must be persistently stored directly on the iOS device. The application needs to ensure that data is saved reliably and is available across application launches. Given the personal nature of the app, local storage is sufficient, and there is no initial requirement for cloud synchronization or backup features, although the data structure should be designed in a way that might allow for future export or backup functionality if desired.

## 3. Non-Functional Requirements

### 3.1. User Interface and User Experience (UI/UX)

The application's interface must strictly adhere to Apple's Human Interface Guidelines (HIG). This implies prioritizing clarity, deference (letting content shine), and depth through intuitive navigation and standard iOS controls. The design should feel native to the platform, employing familiar patterns and components to ensure ease of use for anyone accustomed to iOS. The user experience must be seamless and efficient, particularly the log entry process, which should be quick and require minimal friction. Data presentation in the history and detail views needs to be clean, readable, and well-organized. The overall interaction should feel responsive and fluid, avoiding lag or complex workflows.

### 3.2. Technology Stack

The application will be developed targeting the iOS platform. As per the user's preference, the primary programming language will be Kotlin. This necessitates the use of Kotlin Multiplatform (KMP) technology to enable Kotlin code to run on iOS. It is expected that core application logic, including data management, business rules, and the suggestion engine, will reside in shared Kotlin modules. The user interface layer, however, will need to be implemented using native iOS frameworks like SwiftUI or UIKit, interacting with the shared Kotlin code via the mechanisms provided by KMP. This hybrid approach aims to leverage Kotlin development preferences while delivering a fully native iOS look, feel, and performance.

### 3.3. Data Storage

Local data persistence will be handled using appropriate on-device storage mechanisms available within the iOS ecosystem and compatible with KMP. Options could include Core Data, Realm (if a KMP-compatible version is suitable), SQLite databases accessed via libraries like SQLDelight, or potentially simpler methods like property lists or file storage if the data complexity remains low. The chosen solution must ensure data integrity and reasonable performance for querying and writing log entries.

### 3.4. Maintainability

As the application is being developed by the user and a friend for personal use, the codebase should be structured logically, well-commented, and follow standard coding conventions. This will facilitate understanding, future modifications, and collaborative development.

## 4. Data Model (Conceptual)

A central entity will be the `BrewLog`. Each `BrewLog` instance would contain attributes such as:

*   `logID` (Unique Identifier)
*   `timestamp` (Date and Time of logging)
*   `coffeeType` (String, Mandatory)
*   `coffeeGrams` (Double/Float, Mandatory)
*   `waterGrams` (Double/Float, Mandatory)
*   `grindSetting` (String/Double, Mandatory)
*   `waterTemperature` (Double/Float, Optional)
*   `temperatureUnit` (Enum: Celsius/Fahrenheit, Optional)
*   `brewMethod` (String/Enum, Optional)
*   `beanOrigin` (String, Optional)
*   `roastLevel` (String/Enum, Optional)
*   `brewTimeSeconds` (Integer, Optional)
*   `tasteRating` (Integer/Enum, Optional)
*   `tasteNotes` (String, Optional)

Relationships might exist implicitly through querying (e.g., finding all logs for a specific `coffeeType`).

## 5. Future Considerations

While the current scope is focused on personal logging, future enhancements could include data export/import features, more sophisticated analysis and visualization of brewing trends, integration with smart scales or thermometers, or potentially a shared database if the user decides to collaborate on brewing with others.
