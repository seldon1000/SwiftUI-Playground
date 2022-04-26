//
//  PlaygroundModel.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 11/04/22.
//

import SwiftUI

class PlaygroundModel: ObservableObject {
    @Published var frameWidth: CGFloat = 128
    @Published var frameHeight: CGFloat = 128
    @Published var foregroundColor: Color = .red
    @Published var rotationEffect: Double = 0
    @Published var opacity: Double = 1
    @Published var scaleEffect: Double = 1
    @Published var cornerRadius: Double = 0
    @Published var shadowRadius: Double = 0
    @Published var shadowColor: Color = .white
    @Published var shadowX: CGFloat = 0
    @Published var shadowY: CGFloat = 0
    @Published var borderColor: Color = .white
    @Published var borderWidth: CGFloat = 0
    @Published var blurRadius: CGFloat = 0
    @Published var brigthness: Double = 0
    
    func resetModel() {
        restoreFrame()
        restoreForegroundColor()
        restoreRotationEffect()
        restoreOpacity()
        restoreScaleEffect()
        restoreCornerRadius()
        restoreShadow()
        restoreBorder()
        restoreBlur()
        restoreBrightness()
    }
    
    func restoreFrame() {
        frameWidth = 128
        frameHeight = 128
    }
    
    func restoreForegroundColor() {
        foregroundColor = .red
    }
    
    func restoreRotationEffect() {
        rotationEffect = 0
    }
    
    func restoreOpacity() {
        opacity = 1
    }
    
    func restoreScaleEffect() {
        scaleEffect = 1
    }
    
    func restoreCornerRadius() {
        cornerRadius = 0
    }
    
    func restoreShadow() {
        shadowColor = .white
        shadowRadius = 0
        shadowX = 0
        shadowY = 0
    }
    
    func restoreBorder() {
        borderColor = .white
        borderWidth = 0
    }
    
    func restoreBlur() {
        blurRadius = 0
    }
    
    func restoreBrightness() {
        brigthness = 0
    }
}
