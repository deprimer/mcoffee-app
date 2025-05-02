import SwiftUI

struct ContentView: View {
    // Use @StateObject to create and manage the ViewModel instance
    @StateObject private var viewModel = BrewLogViewModel()
    
    var body: some View {
        NavigationStack {
            // Pass the ViewModel to the list view
            BrewLogListView()
                .environmentObject(viewModel)
        }
    }
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BrewLogViewModel()) // Provide VM for preview
    }
}
