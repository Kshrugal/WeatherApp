//
//  LottieView.swift
//  WeatherApp1
//
//  Created by Kshrugal Jain on 10/23/24.
//


import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loop: Bool = true
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: name)
        view.loopMode = loop ? .loop : .playOnce
        return view
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // You can update the Lottie view here if needed
    }
}
