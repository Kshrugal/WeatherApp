//
//  CustomSlider.swift
//  WeatherApp1
//
//  Created by Kshrugal Jain on 10/24/24.
//


import SwiftUI

struct CCustomSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var trackColor: Color
    var thumbColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width
            let thumbSize: CGFloat = 20
            
            ZStack(alignment: .leading) {
                // Track background
                RoundedRectangle(cornerRadius: 10)
                    .fill(trackColor.opacity(0.3))
                    .frame(height: 8)
                
                // Active track
                RoundedRectangle(cornerRadius: 10)
                    .fill(trackColor)
                    .frame(width: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * sliderWidth, height: 8)
                
                // Thumb (handle)
                Circle()
                    .fill(thumbColor)
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * sliderWidth - thumbSize / 2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gestureValue in
                                let percentage = gestureValue.location.x / sliderWidth
                                let newValue = range.lowerBound + Double(percentage) * (range.upperBound - range.lowerBound)
                                value = min(max(newValue, range.lowerBound), range.upperBound)
                            }
                    )
            }
        }
        .frame(height: 20) // Overall slider height
    }
}


