import SwiftUI

struct BrewLogDetailView: View {
    @EnvironmentObject var viewModel: BrewLogViewModel
    @State private var isPresentingEditSheet = false

    private let logID: UUID

    private var log: BrewLog {
        guard let foundLog = viewModel.brewLogs.first(where: { $0.id == logID }) else {
            fatalError("Log not found")
        }
        return foundLog
    }

    init(log: BrewLog) {
        self.logID = log.id
    }

    var body: some View {
        Form {
            Section("Coffee Details") {
                HStack {
                    Text("Coffee Name")
                    Spacer()
                    Text(log.coffeeName)
                        .foregroundColor(.secondary)
                }
                if !log.roastLevel.isEmpty {
                    HStack {
                        Label("Roast Level", systemImage: "flame")
                        Spacer()
                        Text(log.roastLevel)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section("Grinder") {
                HStack {
                    Label("Grinder Name", systemImage: "gearshape.2")
                    Spacer()
                    Text(log.grinderType)
                        .foregroundColor(.secondary)
                }
                if !log.grindSetting.isEmpty {
                    HStack {
                        Label("Grind Setting", systemImage: "gearshape")
                        Spacer()
                        Text(log.grindSetting)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section("Brew Parameters") {
                HStack {
                    Label("Method", systemImage: "timer")
                    Spacer()
                    Text(log.method.capitalized)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Dose", systemImage: "scalemass")
                    Spacer()
                    Text("\(log.dose, specifier: "%.1f") g")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Ratio", systemImage: "scalemass.fill")
                    Spacer()
                    Text("1:\(Int(log.waterAmount / log.dose))")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Water Amount", systemImage: "drop")
                    Spacer()
                    Text("\(log.waterAmount, specifier: "%.1f") ml")
                        .foregroundColor(.secondary)
                }
                if let temp = log.waterTemperature {
                    HStack {
                        Label("Water Temp", systemImage: "thermometer.medium")
                        Spacer()
                        Text("\(temp, specifier: "%.1f")°\(log.temperatureUnit == "celsius" ? "C" : "F")")
                            .foregroundColor(.secondary)
                    }
                }
                if let brewTime = log.brewTime {
                    HStack {
                        Label("Brew Time", systemImage: "hourglass")
                        Spacer()
                        Text(formatBrewTime(brewTime))
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section("Notes & Rating") {
                if let rating = log.rating {
                    HStack {
                        Label("Rating", systemImage: "star")
                        Spacer()
                        Text("\(rating)/5")
                            .foregroundColor(.secondary)
                    }
                }
                if let notes = log.notes, !notes.isEmpty {
                    VStack(alignment: .leading) {
                        Label("Notes", systemImage: "note.text")
                        Text(notes)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                    }
                }
            }
        }
        .navigationTitle("Log Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isPresentingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            AddBrewLogView(viewModel: viewModel, logToEdit: log)
// Rely on environment propagation for the sheet
        }
    }
    
    // Helper function to format seconds into MM:SS
    private func formatBrewTime(_ time: Double?) -> String {
        guard let totalSeconds = time, totalSeconds > 0 else { return "N/A" }
        let seconds = Int(totalSeconds)
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    NavigationView {
        BrewLogDetailView(log: BrewLog(coffeeName: "Preview Coffee", dose: 18.0, grindSetting: "Medium", waterAmount: 300, method: "Pour Over", roastLevel: "Medium", waterTemperature: 95.5, temperatureUnit: "C", brewTime: 185.0, notes: "Preview notes.", rating: 4))
            .environmentObject(BrewLogViewModel())
    }
}
