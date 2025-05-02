import Foundation

// MARK: - Swift Enums (Replacing Kotlin Enums)

enum BrewMethod: String, CaseIterable, Identifiable {
    case pourOver = "Pour Over"
    case aeropress = "Aeropress"
    case frenchPress = "French Press"
    case espresso = "Espresso"
    case siphon = "Siphon"
    case coldBrew = "Cold Brew"
    case mokaPot = "Moka Pot"
    case turkish = "Turkish"
    case other = "Other"

    var id: String { self.rawValue }
}

enum RoastLevel: String, CaseIterable, Identifiable {
    case light = "Light"
    case mediumLight = "Medium-Light"
    case medium = "Medium"
    case mediumDark = "Medium-Dark"
    case dark = "Dark"
    case unknown = "Unknown"

    var id: String { self.rawValue }
}

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"

    var id: String { self.rawValue }
}
