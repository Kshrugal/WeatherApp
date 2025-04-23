//
//  CustomSliderStyle.swift
//  WeatherApp1
//
//  Created by Kshrugal Jain on 10/24/24.
//


import SwiftUI

struct CustomSliderStyle: SliderStyle {
    var trackColor: Color
    var thumbColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width
            let thumbSize: CGFloat = 20
            
            ZStack(alignment: .leading) {
                // Track background
                RoundedRectangle(cornerRadius: 10)
                    .fill(trackColor)
                    .frame(height: 8)
                
                // Active track
                RoundedRectangle(cornerRadius: 10)
                    .fill(trackColor.opacity(0.6))
                    .frame(width: sliderWidth * CGFloat(configuration.value), height: 8)
                
                // Thumb (handle)
                Circle()
                    .fill(thumbColor)
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: sliderWidth * CGFloat(configuration.value) - thumbSize / 2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let percentage = value.location.x / sliderWidth
                                configuration.onEditingChanged(true)
                                configuration.value = min(max(Double(percentage), 0.0), 1.0)
                            }
                            .onEnded { _ in
                                configuration.onEditingChanged(false)
                            }
                    )
            }
        }
        .frame(height: 20) // Adjust the overall slider height
    }
}
