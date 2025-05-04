import Foundation

// Basic Swift representation of a Brew Log
// We'll add more properties and persistence logic later
struct BrewLog: Identifiable, Codable, Hashable { // Add Codable back for persistence
    let id: UUID // Using UUID for local identification
    var timestamp: Date
    var coffeeName: String
    var dose: Double // in grams
    var grindSetting: String
    var waterAmount: Double // in ml or grams
    var method: String // Store enum rawValue
    var roastLevel: String // Store enum rawValue
    var waterTemperature: Double? // in Celsius or Fahrenheit
    var temperatureUnit: String? // Store enum rawValue
    var brewTime: Double? // in seconds
    var notes: String? 
    var rating: Int? // e.g., 1-5 stars
    var grinderType: String = "Fellow Ode"
    
    // Placeholder initializer
    init(id: UUID = UUID(), timestamp: Date = Date(), coffeeName: String = "Sample Coffee", dose: Double = 18.0, grindSetting: String = "Medium", waterAmount: Double = 250.0, method: String = "pourOver", roastLevel: String = "medium", waterTemperature: Double? = 94.0, temperatureUnit: String? = "celsius", brewTime: Double? = 180.0, notes: String? = nil, rating: Int? = nil, grinderType: String = "Fellow Ode") {
        self.id = id
        self.timestamp = timestamp
        self.coffeeName = coffeeName
        self.dose = dose
        self.grindSetting = grindSetting
        self.waterAmount = waterAmount
        self.method = method
        self.roastLevel = roastLevel
        self.waterTemperature = waterTemperature
        self.temperatureUnit = temperatureUnit
        self.brewTime = brewTime
        self.notes = notes
        self.rating = rating
        self.grinderType = grinderType
    }
    
    // Example static data for previews
    static let example = BrewLog()
    static let examples = [
        BrewLog(),
        BrewLog(coffeeName: "Another Coffee", dose: 20.0, grindSetting: "Fine", waterAmount: 300.0)
    ]
}
