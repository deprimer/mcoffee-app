import SwiftUI

struct AddBrewLogView: View {
    // Change from EnvironmentObject to ObservedObject
    @ObservedObject var viewModel: BrewLogViewModel
    @Environment(\.dismiss) var dismiss

    // Optional log to edit
    let logToEdit: BrewLog?

    // State variables for form fields
    @State private var coffeeName: String = ""
    @State private var doseString: String = ""
    @State private var grindSetting: String = ""
    @State private var waterAmountString: String = ""
    @State private var selectedMethod: BrewMethod = .pourOver
    @State private var selectedRoastLevel: RoastLevel = .medium
    @State private var waterTemperatureString: String = ""
    @State private var selectedTempUnit: TemperatureUnit = .celsius
    @State private var brewTimeString: String = ""
    @State private var notes: String = ""
    @State private var timestamp: Date = Date()
    // Non-optional state for Stepper binding
    @State private var stepperRating: Int = 3

    // Determine if we are editing or adding
    var isEditing: Bool {
        logToEdit != nil
    }

    // Computed property to check if the form is valid (basic check)
    var isFormValid: Bool {
        !coffeeName.isEmpty &&
        Double(doseString) != nil &&
        !grindSetting.isEmpty &&
        Double(waterAmountString) != nil &&
        (waterTemperatureString.isEmpty || Double(waterTemperatureString) != nil) &&
        (brewTimeString.isEmpty || parseMMSS(brewTimeString) != nil)
    }

    // Helper function to format total seconds into MM:SS string
    private func formatSecondsToMMSS(_ totalSeconds: Double) -> String {
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Helper function to parse MM:SS string into total seconds
    private func parseMMSS(_ timeString: String) -> Double? {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let minutes = Int(components[0]),
              let seconds = Int(components[1]) else {
            return nil // Invalid format
        }
        guard minutes >= 0 && seconds >= 0 && seconds < 60 else {
            return nil // Invalid values
        }
        return Double(minutes * 60 + seconds)
    }

    // Initializer
    init(viewModel: BrewLogViewModel, logToEdit: BrewLog? = nil) { // Add viewModel parameter
        self.viewModel = viewModel // Assign passed viewModel
        self.logToEdit = logToEdit

        // Initialize state based on logToEdit or defaults
        _timestamp = State(initialValue: logToEdit?.timestamp ?? Date())
        _coffeeName = State(initialValue: logToEdit?.coffeeName ?? "")
        // Safely initialize doseString and waterAmountString
        _doseString = State(initialValue: logToEdit != nil ? String(format: "%.1f", logToEdit!.dose) : "")
        _grindSetting = State(initialValue: logToEdit?.grindSetting ?? "")
        _waterAmountString = State(initialValue: logToEdit != nil ? String(format: "%.1f", logToEdit!.waterAmount) : "")
        _selectedMethod = State(initialValue: BrewMethod(rawValue: logToEdit?.method ?? BrewMethod.pourOver.rawValue) ?? .pourOver)
        _selectedRoastLevel = State(initialValue: RoastLevel(rawValue: logToEdit?.roastLevel ?? RoastLevel.medium.rawValue) ?? .medium)
        // Initialize waterTemperatureString safely
        _waterTemperatureString = State(initialValue: logToEdit?.waterTemperature != nil ? String(format: "%.1f", logToEdit!.waterTemperature!) : "")
        _selectedTempUnit = State(initialValue: TemperatureUnit(rawValue: logToEdit?.temperatureUnit ?? TemperatureUnit.celsius.rawValue) ?? .celsius)
        // Initialize brewTimeString safely
        _brewTimeString = State(initialValue: logToEdit?.brewTime != nil ? formatSecondsToMMSS(logToEdit!.brewTime!) : "")
        _notes = State(initialValue: logToEdit?.notes ?? "")
        // Use the optional rating, default to 3 if nil or adding
        _stepperRating = State(initialValue: logToEdit?.rating ?? 3)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Coffee Details") {
                    TextField("Coffee Name", text: $coffeeName)
                    Picker("Roast Level", selection: $selectedRoastLevel) {
                        ForEach(RoastLevel.allCases) { level in
                            Text(level.rawValue.capitalized).tag(level)
                        }
                    }
                }
                
                Section("Brew Parameters") {
                    Picker("Method", selection: $selectedMethod) {
                        ForEach(BrewMethod.allCases) { method in
                            Text(method.rawValue.capitalized).tag(method)
                        }
                    }
                    HStack {
                        Text("Dose (g)")
                        TextField("e.g., 18.0", text: $doseString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    TextField("Grind Setting", text: $grindSetting)
                    HStack {
                        Text("Water Amount (ml)")
                        TextField("e.g., 250", text: $waterAmountString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    Picker("Roast Level", selection: $selectedRoastLevel) {
                        ForEach(RoastLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    HStack {
                        Text("Water Temp")
                        TextField("Optional", text: $waterTemperatureString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Picker("Unit", selection: $selectedTempUnit) {
                            ForEach(TemperatureUnit.allCases) { unit in
                                Text(unit.rawValue.prefix(1)).tag(unit) // Show C or F
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 100) // Constrain width for segmented picker
                    }
                    HStack {
                        Text("Brew Time (sec)")
                        TextField("Optional", text: $brewTimeString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    DatePicker("Date", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Notes & Rating") {
                    TextField("Tasting Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...)
                    // Bind Stepper to the non-optional state variable
                    Stepper("Rating: \(stepperRating)/5", value: $stepperRating, in: 1...5)
                }
            }
            .navigationTitle(isEditing ? "Edit Brew Log" : "Add Brew Log") // Dynamic title
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        print("--- Save Action Started ---")
                        print("Raw Inputs: dose='\(doseString)', waterAmount='\(waterAmountString)', grind='\(grindSetting)', waterTemp='\(waterTemperatureString)', brewTime='\(brewTimeString)'")
                        
                        // Convert string inputs to appropriate types
                        guard let dose = Double(doseString), let waterAmount = Double(waterAmountString) else {
                            // This should ideally be handled by isFormValid, but good to double-check
                            print("Error: Invalid numeric input for dose or waterAmount.")
                            return
                        }
                        
                        let waterTemperature = Double(waterTemperatureString) // Optional
                        // Use parseMMSS for brew time
                        let brewTime = parseMMSS(brewTimeString) // Optional Double
                        
                        print("Parsed Values: dose=\(dose), waterAmount=\(waterAmount), grind='\(grindSetting)', waterTemp=\(waterTemperature ?? -1), brewTime=\(brewTime ?? -1), rating=\(stepperRating)")
                        
                        // Create the new BrewLog instance
                        print("Creating BrewLog instance...")
                        let newLog = BrewLog(
                            id: logToEdit?.id ?? UUID(), // Use existing ID if editing
                            timestamp: timestamp, // Use the state variable
                            coffeeName: coffeeName,
                            dose: dose,
                            grindSetting: grindSetting,
                            waterAmount: waterAmount,
                            method: selectedMethod.rawValue,
                            roastLevel: selectedRoastLevel.rawValue,
                            waterTemperature: waterTemperature,
                            // Pass unit only if temperature exists, matching BrewLog's String? type
                            temperatureUnit: waterTemperature != nil ? selectedTempUnit.rawValue : nil,
                            brewTime: brewTime,
                            notes: notes.isEmpty ? nil : notes, // Store nil if notes are empty
                            // Use the non-optional value from the stepper for saving
                            rating: self.stepperRating
                        )
                        
                        // Add or update the log using the ViewModel
                        if isEditing {
                            print("Calling viewModel.updateLog for ID: \(newLog.id)")
                            viewModel.updateLog(newLog)
                            print("viewModel.updateLog finished")
                        } else {
                            print("Calling viewModel.addBrewLog")
                            viewModel.addBrewLog(newLog) // Correct function name from ViewModel
                            print("viewModel.addBrewLog finished")
                        }
                        
                        print("Dismissing AddBrewLogView...")
                        // Dismiss the view
                        dismiss()
                    }
                    .disabled(!isFormValid) // Keep disable logic
                }
            }
        }
    }
}

// Preview Provider
struct AddBrewLogView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample ViewModel for the preview
        AddBrewLogView(viewModel: BrewLogViewModel(), logToEdit: BrewLog(coffeeName: "Preview Edit", dose: 15.0, grindSetting: "Fine", waterAmount: 250, method: "Aeropress", roastLevel: "Light", waterTemperature: 92.0, temperatureUnit: "C", brewTime: 120.0, notes: "Editing preview notes", rating: 5))
    }
}
