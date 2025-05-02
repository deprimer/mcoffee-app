import SwiftUI

struct BrewLogListView: View {
    // Observe the ViewModel passed from ContentView
    @EnvironmentObject var viewModel: BrewLogViewModel
    
    // Add state for presenting sheet
    @State private var isPresentingAddSheet = false

    var body: some View {
        // Remove NavigationView wrapper
        ScrollView { // ScrollView starts here
            LazyVStack(spacing: 15) { // LazyVStack for efficient vertical layout, add spacing between cards
                ForEach(viewModel.brewLogs) { log in
                    // Wrap the row in a NavigationLink
                    NavigationLink(destination: 
                        BrewLogDetailView(log: log)
                            .environmentObject(viewModel) // Explicitly pass the environment object
                    ) {
                        BrewLogCardView(log: log)
                            .padding(.horizontal) // Add horizontal padding to cards
                    }
                    .buttonStyle(PlainButtonStyle()) // Prevents the entire card from looking like a button
                }
            }
            .padding(.top) // Add padding at the top of the stack
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure ScrollView has a frame for the overlay
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
        } // ScrollView ends here
        // Apply navigation title and toolbar to the ScrollView
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
