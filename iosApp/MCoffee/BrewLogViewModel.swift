import Foundation
import SwiftUI

@MainActor // Ensure UI updates happen on the main thread
class BrewLogViewModel: ObservableObject {
    
    @Published var brewLogs: [BrewLog] = [] {
        // Automatically save whenever the array changes
        didSet {
            saveLogs()
        }
    }
    
    // Key for UserDefaults
    private let userDefaultsKey = "brewLogsData"
        
    init() {
        // Load saved logs on initialization
        loadLogs()
    }
    
    func addBrewLog(_ log: BrewLog) {
        brewLogs.append(log)
        // No need to call saveLogs() here, didSet handles it
    }
    
    // Function to update an existing log
    func updateLog(_ updatedLog: BrewLog) {
        // Find the index of the log with the same ID
        if let index = brewLogs.firstIndex(where: { $0.id == updatedLog.id }) {
            brewLogs[index] = updatedLog
            // No need to call saveLogs() here, didSet handles it
            print("Log updated successfully.")
        } else {
            print("Failed to find log with ID \(updatedLog.id) to update.")
        }
    }
    
    // Function to delete logs at specific indices
    func deleteLog(at offsets: IndexSet) {
        brewLogs.remove(atOffsets: offsets)
        // No need to call saveLogs() here, didSet handles it
    }
    
    private func saveLogs() {
        let encoder = JSONEncoder()
        // Attempt to encode the logs array
        if let encodedData = try? encoder.encode(brewLogs) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
            print("Logs saved successfully.")
        } else {
            print("Failed to encode logs for saving.")
        }
    }
    
    private func loadLogs() {
        // Attempt to retrieve data from UserDefaults
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            print("No saved logs found. Starting fresh or using sample data.")
            // Optionally load sample data if nothing is saved
            // loadSampleData()
            return
        }
        
        let decoder = JSONDecoder()
        // Attempt to decode the data back into an array of BrewLog
        if let decodedLogs = try? decoder.decode([BrewLog].self, from: savedData) {
            self.brewLogs = decodedLogs
            print("Logs loaded successfully: \(brewLogs.count) logs.")
        } else {
            print("Failed to decode saved logs. Starting fresh.")
            // Handle decoding failure, maybe clear corrupted data or load samples
            self.brewLogs = [] // Start with an empty list
            // loadSampleData()
        }
    }
    
    // Function to load sample data (replace with actual persistence later)
    private func loadSampleData() {
        // Use the static examples from the BrewLog model if they exist,
        // otherwise create some simple ones here.
        if !BrewLog.examples.isEmpty {
            self.brewLogs = BrewLog.examples
        } else {
            self.brewLogs = [
                BrewLog(coffeeName: "Morning Delight", dose: 18.5, grindSetting: "Medium-Fine", waterAmount: 300, method: BrewMethod.pourOver.rawValue, roastLevel: RoastLevel.light.rawValue, waterTemperature: 96, temperatureUnit: TemperatureUnit.celsius.rawValue, brewTime: 180, notes: "First attempt with new beans.", rating: 4),
                BrewLog(coffeeName: "Dark Roast", dose: 20.0, grindSetting: "Coarse", waterAmount: 320, method: BrewMethod.frenchPress.rawValue, roastLevel: RoastLevel.dark.rawValue, waterTemperature: 92, temperatureUnit: TemperatureUnit.celsius.rawValue, brewTime: 240, notes: "Strong and bold.", rating: 5)
            ]
        }
    }
    
    // Potential future functions:
    // func updateBrewLog(_ log: BrewLog) { ... }
    // func saveLogs() { ... }
    // func loadLogs() { ... }
}
