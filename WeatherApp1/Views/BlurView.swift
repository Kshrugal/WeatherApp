//
//  BlurView.swift
//  WeatherApp1
//
//  Created by Kshrugal Jain on 10/23/24.
//


import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // No need to update the view
    }
}
