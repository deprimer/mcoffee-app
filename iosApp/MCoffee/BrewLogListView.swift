import SwiftUI

struct BrewLogListView: View {
    // Observe the ViewModel passed from ContentView
    @EnvironmentObject var viewModel: BrewLogViewModel
    
    // Add state for presenting sheet
    @State private var isPresentingAddSheet = false
    // State to track the log selected for navigation
    @State private var selectedLogForNavigation: BrewLog? = nil

    var body: some View {
        // Use List for better swipe-to-delete integration
        List {
            ForEach(viewModel.brewLogs) { log in
                BrewLogCardView(log: log)
                    .contentShape(Rectangle()) // Make the whole area tappable (Re-enabled)
                    .onTapGesture {              // Re-enabled tap gesture
                        selectedLogForNavigation = log
                    }
            }
            .onDelete(perform: viewModel.deleteLog) // Add swipe-to-delete
        }
        .listStyle(.plain) // Use plain style to remove default list background/insets
        .overlay {
            if viewModel.brewLogs.isEmpty {
                ContentUnavailableView(
                    "No Brew Logs Yet",
                    systemImage: "cup.and.saucer.fill",
                    description: Text("Tap the + button to add your first brew log.")
                )
            }
        }
        .sheet(isPresented: $isPresentingAddSheet) {
            // Pass the viewModel for adding a new log
            AddBrewLogView(viewModel: viewModel)
        }
        // Move navigation destination to the List
        .navigationDestination(item: $selectedLogForNavigation) { log in
            BrewLogDetailView(log: log)
                .environmentObject(viewModel) // Pass environment object to the destination
        }
        // Apply navigation title and toolbar to the List
        .navigationTitle("Brew Logs")
        .toolbar { 
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isPresentingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

// Preview Provider
struct BrewLogListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample ViewModel for the preview
        let sampleViewModel = BrewLogViewModel()
        // You might need to ensure sampleViewModel has data for preview
        // sampleViewModel.loadSampleData() // Already called in init
        
        NavigationView { // Wrap in NavigationView for title display
            BrewLogListView()
                .environmentObject(sampleViewModel)
                .navigationTitle("Sample Logs")
        }
    }
}
