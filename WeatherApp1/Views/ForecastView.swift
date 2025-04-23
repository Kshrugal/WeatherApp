import SwiftUI

struct ForecastView: View {
    var day: String
    var icon: String
    var temp: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)

            Text(day)
                .foregroundColor(.white)
                .fontWeight(.medium)

            Text(temp)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .padding()
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
