import SwiftUI

struct AddBrewLogView: View {
    @ObservedObject var viewModel: BrewLogViewModel
    @Environment(\.dismiss) var dismiss
    @State private var logToEdit: BrewLog?

    init(viewModel: BrewLogViewModel, logToEdit: BrewLog? = nil) {
        self.viewModel = viewModel
        self._logToEdit = State(initialValue: logToEdit)
    }

    @State private var coffeeName: String = ""
    @State private var doseString: String = ""
    @State private var grindSetting: String = ""
    @State private var roastLevel: String = RoastLevel.light.rawValue
    @State private var showGrindSetting = false
    @State private var waterAmountString: String = ""
    @State private var selectedMethod: String = "pourOver"
    @State private var waterTemperatureString: String = ""
    @State private var selectedTempUnit: TemperatureUnit = .celsius
    @State private var brewTimeString: String = ""
    @State private var notes: String = ""
    @State private var timestamp: Date = Date()
    @State private var stepperRating: Int = 3
    @State private var selectedRatio: Double = 15.0
    @State private var grinderType: String = "Fellow Ode"

    var isEditing: Bool {
        logToEdit != nil
    }

    var isFormValid: Bool {
        !coffeeName.isEmpty &&
        Double(doseString) != nil &&
        (waterAmountString.isEmpty || Double(waterAmountString) != nil) &&
        (waterTemperatureString.isEmpty || Double(waterTemperatureString) != nil) &&
        (brewTimeString.isEmpty || isValidMMSS(brewTimeString))
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Coffee Details") {
                    HStack {
                        Text("Coffee Name")
                        Spacer()
                        TextField("Enter Coffee Name", text: $coffeeName)
                            .multilineTextAlignment(.trailing)
                        Menu {
                            ForEach(viewModel.brewLogs.map { $0.coffeeName }.unique(), id: \.self) { name in
                                Button(name) { coffeeName = name }
                            }
                        } label: {
                            Image(systemName: "chevron.down.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    Picker("Roast Level", selection: $roastLevel) {
                        ForEach(RoastLevel.allCases) { level in
                            Text(level.rawValue).tag(level.rawValue)
                        }
                    }
                }
                Section("Grinder") {
                    Picker("Grinder Name", selection: $grinderType) {
                        Text("Fellow Ode").tag("Fellow Ode")
                        Text("Comandante").tag("Comandante")
                        Text("Hario").tag("Hario")
                    }
                    TextField("Grind Setting (Optional)", text: $grindSetting)
                }
                Section("Brew Parameters") {
                    Picker("Method", selection: $selectedMethod) {
                        Text("Aeropress").tag("aeropress")
                        Text("Cold Brew").tag("coldBrew")
                        Text("Espresso").tag("espresso")
                        Text("French Press").tag("frenchPress")
                        Text("Kalita").tag("kalita")
                        Text("Moka Pot").tag("mokaPot")
                        Text("Pour Over").tag("pourOver")
                        Text("Pulsar").tag("pulsar")
                        Text("Siphon").tag("siphon")
                        Text("Turkish").tag("turkish")
                        Text("V60").tag("v60")
                        Text("Add New...").tag("Add New...")
                    }
                    .onChange(of: selectedMethod) { _, newValue in
                        if newValue == "Add New..." { selectedMethod = "" }
                    }
                    Picker("Ratio", selection: $selectedRatio) {
                        Text("1:15").tag(15.0)
                        Text("1:16").tag(16.0)
                        Text("1:17").tag(17.0)
                    }
                    .onChange(of: doseString) { _, _ in updateWaterAmount() }
                    .onChange(of: selectedRatio) { _, _ in updateWaterAmount() }
                    HStack {
                        Text("Dose (g)")
                        Spacer()
                        TextField("", text: $doseString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Water Volume (g)")
                        Spacer()
                        TextField("", text: $waterAmountString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Brew Time (MM:SS)")
                        Spacer()
                        TextField("MM:SS", text: $brewTimeString)
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Water Temp")
                        Spacer()
                        TextField("Optional", text: $waterTemperatureString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Picker("Unit", selection: $selectedTempUnit) {
                            ForEach(TemperatureUnit.allCases) { unit in
                                Text(unit.rawValue.prefix(1)).tag(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 100)
                    }
                    DatePicker("Date", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                }
                Section("Notes & Rating") {
                    TextField("Notes", text: $notes)
                        .multilineTextAlignment(.trailing)
                    Stepper(value: $stepperRating, in: 1...5) {
                        HStack {
                            Text("Rating")
                            Spacer()
                            Text("\(stepperRating)")
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Brew Log" : "Add Brew Log")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Add") { saveBrewLog() }
                        .disabled(!isFormValid)
                }
            }
        }
        .onAppear {
            if let log = logToEdit {
                coffeeName = log.coffeeName
                doseString = String(format: "%.1f", log.dose)
                grindSetting = log.grindSetting
                waterAmountString = String(format: "%.1f", log.waterAmount)
                selectedMethod = log.method
                roastLevel = log.roastLevel
                waterTemperatureString = log.waterTemperature.map { String(format: "%.1f", $0) } ?? ""
                selectedTempUnit = TemperatureUnit(rawValue: log.temperatureUnit ?? "celsius") ?? .celsius
                brewTimeString = log.brewTime.map { formatTime($0) } ?? ""
                notes = log.notes ?? ""
                timestamp = log.timestamp
                stepperRating = log.rating ?? 3
                selectedRatio = log.waterAmount / log.dose
                grinderType = log.grinderType
            }
        }
    }

    private func updateWaterAmount() {
        if let dose = Double(doseString) {
            let calculatedAmount = dose * selectedRatio
            waterAmountString = String(format: "%.1f", calculatedAmount)
        }
    }

    private func parseMMSS(_ timeString: String) -> Double? {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let minutes = Double(components[0]),
              let seconds = Double(components[1]),
              seconds < 60 else {
            return nil // Invalid format
        }
        return minutes * 60 + seconds
    }

    private func isValidMMSS(_ timeString: String) -> Bool {
        guard timeString.isEmpty == false else { return true }
        return parseMMSS(timeString) != nil
    }

    private func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds / 60)
        let remainingSeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    private func saveBrewLog() {
        guard isFormValid else {
            // Handle invalid form
            return
        }

        // Create or update BrewLog instance
        let newLog = BrewLog(
            id: logToEdit?.id ?? UUID(),
            timestamp: timestamp,
            coffeeName: coffeeName,
            dose: Double(doseString) ?? 0.0,
            grindSetting: grindSetting,
            waterAmount: Double(waterAmountString) ?? 0.0,
            method: selectedMethod,
            roastLevel: roastLevel,
            waterTemperature: Double(waterTemperatureString),
            temperatureUnit: waterTemperatureString.isEmpty ? nil : selectedTempUnit.rawValue,
            brewTime: brewTimeString.isEmpty ? nil : parseMMSS(brewTimeString),
            notes: notes.isEmpty ? nil : notes,
            rating: stepperRating,
            grinderType: grinderType
        )

        if isEditing {
            viewModel.updateLog(newLog)
        } else {
            viewModel.addBrewLog(newLog)
        }

        dismiss()
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
