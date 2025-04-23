import SwiftUI
import Lottie

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?

    var body: some View {
        ZStack {
            // Display the Lottie animation as a background based on time of day
            LottieView(name: lottieAnimationForTimeOfDay())
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let location = locationManager.location {
                    if let weather = weather {
                        WeatherView(weather: weather)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                    weather = try await weatherManager.getCurrentWeather(
                                        latitude: location.latitude,
                                        longitude: location.longitude
                                    )
                                } catch {
                                    print("Error getting weather: \(error)")
                                }
                            }
                    }
                } else {
                    if locationManager.isLoading {
                        LoadingView()
                    } else {
                        WelcomeView().environmentObject(locationManager)
                    }
                }
            }
        }
    }
    
    // Function to determine the appropriate Lottie animation based on time of day
    private func lottieAnimationForTimeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDayTime = hour >= 6 && hour < 18
        
        return isDayTime ? "day" : "night"
    }
}

#Preview {
    ContentView()
}
