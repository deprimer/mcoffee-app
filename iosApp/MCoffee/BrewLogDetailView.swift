import SwiftUI

struct BrewLogDetailView: View {
    @EnvironmentObject var viewModel: BrewLogViewModel
    @State private var isPresentingEditSheet = false

    let log: BrewLog

    var body: some View {
        Form {
            Section("Coffee Details") {
                HStack {
                    Label("Name", systemImage: "cup.and.saucer")
                    Spacer()
                    Text(log.coffeeName)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Roast Level", systemImage: "flame")
                    Spacer()
                    Text(log.roastLevel.capitalized)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Date", systemImage: "calendar")
                    Spacer()
                    Text(log.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .foregroundColor(.secondary)
                }
            }

            Section("Brewing Parameters") {
                HStack {
                    Label("Method", systemImage: "timer") // Using timer as placeholder
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
                    Label("Grind Setting", systemImage: "gearshape.2") // Placeholder icon
                    Spacer()
                    Text(log.grindSetting)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Water Amount", systemImage: "drop")
                    Spacer()
                    Text("\(log.waterAmount, specifier: "%.1f") ml")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Label("Water Temp", systemImage: "thermometer.medium")
                    Spacer()
                    if let temp = log.waterTemperature {
                        Text("\(temp, specifier: "%.1f")°\(log.temperatureUnit == "celsius" ? "C" : "F")")
                           .foregroundColor(.secondary)
                    } else {
                        Text("N/A").foregroundColor(.secondary)
                    }
                }
                HStack {
                    Label("Brew Time", systemImage: "hourglass")
                    Spacer()
                    Text(formatBrewTime(log.brewTime))
                        .foregroundColor(.secondary)
                }
            }

            Section("Notes & Rating") {
                HStack {
                    Label("Rating", systemImage: "star")
                    Spacer()
                    if let rating = log.rating {
                        Text("\(rating)/5")
                           .foregroundColor(.secondary)
                    } else {
                        Text("N/A").foregroundColor(.secondary)
                    }
                }
                // Display Notes if they exist
                if let notes = log.notes, !notes.isEmpty {
                    VStack(alignment: .leading) { // Use VStack for multi-line notes
                        Label("Notes", systemImage: "note.text")
                        Text(notes)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                    }
                } else {
                     HStack {
                         Label("Notes", systemImage: "note.text")
                         Spacer()
                         Text("N/A").foregroundColor(.secondary)
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
