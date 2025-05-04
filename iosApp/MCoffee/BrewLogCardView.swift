import SwiftUI

struct BrewLogCardView: View {
    let log: BrewLog

    var body: some View {
        VStack(alignment: .leading, spacing: 10) { // Slightly increase spacing
            HStack {
                Text(log.coffeeName)
                    .font(.headline)
                    .fontWeight(.bold) // Make coffee name bold
                Spacer()
                // Display Rating Stars
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: starType(for: index))
                            .foregroundColor(.yellow)
                            .font(.caption) // Smaller stars
                    }
                }
                HStack(spacing: 4) { // Group date icon and text
                    Image(systemName: "calendar")
                    Text(log.timestamp.formatted(date: .abbreviated, time: .omitted))
                }
                .font(.caption) // Apply caption style to the HStack
                .foregroundColor(.gray)
            }
            
            // Group brew parameters with icons
            HStack(spacing: 15) { // Add more spacing between parameter groups
                HStack(spacing: 4) {
                    Image(systemName: "scalemass")
                    Text("\(log.dose, specifier: "%.1f")g")
                }

                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                    Text("\(log.waterAmount, specifier: "%.0f")ml")
                }

                // Display Brew Method (No specific icon yet, consider adding later)
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                    Text("\(log.method.capitalized)")
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "scalemass.fill")
                    Text("1:\(Int(log.waterAmount / log.dose))")
                }

                Spacer() // Push parameters to the left
            }
            .font(.subheadline) // Smaller font for parameters
            .foregroundColor(.secondary) // Use secondary color for less emphasis

        }
        .padding() // Add padding inside the card
        .background(Color(.systemGray6)) // Card background color
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2) // Subtle shadow
    }

    // Helper to determine star type for rating
    private func starType(for index: Int) -> String {
        guard let rating = log.rating else { return "star" } // Default to empty if no rating
        
        if index <= rating {
            return "star.fill"
        } else {
            return "star"
        }
        // Note: This simple version doesn't handle half stars.
        // For half stars, you'd need more complex logic based on the rating value.
    }
}

struct BrewLogCardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample log for previewing
        let sampleLog = BrewLog(
            id: UUID(), 
            timestamp: Date(), 
            coffeeName: "Ethiopian Yirgacheffe Special Long Name", 
            dose: 18.5, 
            grindSetting: "Medium-Fine", 
            waterAmount: 260.0, 
            method: "Pour Over", 
            roastLevel: "Light", 
            waterTemperature: 94.0, 
            temperatureUnit: "celsius", 
            brewTime: 195.0, 
            notes: "Fruity notes, very acidic, bright finish.", 
            rating: 4
        )
        BrewLogCardView(log: sampleLog)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
