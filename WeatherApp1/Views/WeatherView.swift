import SwiftUI
import Lottie
import UIKit

struct WeatherView: View {
    
    var weather: ResponseBody

    @State private var weatherIconScale: CGFloat = 1.0
    @State private var isMetric: Bool = true // State variable for unit switch
    @Namespace private var animation

    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        ZStack(alignment: .leading) {
            // Display the Lottie animation as a background
            LottieView(name: lottieAnimation(for: weather.weather[0].main))
                .edgesIgnoringSafeArea(.all)
            LottieView(name: lottieAnimation2(for: weather.weather[0].main))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header with city name and unit toggle
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(weather.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()
                        
                        Button(action: {
                            isMetric.toggle() // Toggle the unit system
                        }) {
                            Text(isMetric ? "Switch to Imperial" : "Switch to Metric")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(BlurView(style: .light))
                                .cornerRadius(8)
                        }
                    }
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Weather icon and current temperature
                HStack {
                    VStack(spacing: 20) {
                        Image(systemName: weatherIcon(for: weather.weather[0].main))
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .scaleEffect(weatherIconScale)
                            .matchedGeometryEffect(id: "weatherIcon", in: animation)
                            .onAppear {
                                withAnimation(.spring()) {
                                    weatherIconScale = 1.2
                                }
                            }
                            .onDisappear {
                                withAnimation(.spring()) {
                                    weatherIconScale = 1.0
                                }
                            }
                            .padding(.top, -70)
                        Text(weather.weather[0].main)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 15)
                    .frame(width: .infinity, alignment: .leading)

                    Spacer()

                    Text(formatTemperature(weather.main.temp))
                        .font(.system(size: 120))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 130)
                        .padding(.trailing, 40)
                        .transition(.scale)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Bottom weather details
                VStack(alignment: .leading, spacing: 15) {
                    Text("Weather now:")
                        .bold()
                        .padding(.bottom, 10)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        WeatherRow(logo: "thermometer.low", name: "Min temp", value: formatTemperature(weather.main.tempMin))
                        Spacer()
                        WeatherRow(logo: "thermometer.high", name: "Max temp", value: formatTemperature(weather.main.tempMax))
                    }
                    .padding(.bottom, 10)
                    HStack(spacing: 20) {
                        WeatherRow(logo: "wind", name: "Wind speed", value: formatSpeed(weather.wind.speed))
                        Spacer()
                        WeatherRow(logo: "humidity", name: "Humidity", value: weather.main.humidity.roundDouble() + "%")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(radius: 10)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
    }

    private func formatTemperature(_ temp: Double) -> String {
        let convertedTemp = isMetric ? temp : temp * 9 / 5 + 32
        return "\(Int(round(convertedTemp)))°"
    }

    
    private func lottieAnimation2(for main: String) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDayTime = hour >= 6 && hour < 18
        return isDayTime ? "day.json" : "night.json"
    }

    private func weatherIcon(for main: String) -> String {
        switch main {
        case "Clouds":
            return "cloud.fill"
        case "Rain":
            return "cloud.rain.fill"
        case "Snow":
            return "cloud.snow.fill"
        case "Clear":
            return "sun.max.fill"
        default:
            return "sun.max"
        }
    }
    
    private func lottieAnimation(for main: String) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDayTime = hour >= 6 && hour < 18
        return isDayTime ? "day.json" : "night.json"
    }
    
    private func formatSpeed(_ speed: Double) -> String {
        let convertedSpeed = isMetric ? speed : speed * 2.237
        return String(format: "%.1f %@", convertedSpeed, "mph")
    }
}

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loopMode
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    WeatherView(weather: previewWeather)
}
