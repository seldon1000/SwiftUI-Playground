//
//  Playground.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 11/04/22.
//

import SwiftUI

struct Playground: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var sourceView: Bool = false
    @State var lastChange: (CGFloat, CGFloat) = (0, 0)
    @State var position: (CGFloat, CGFloat) = (UIScreen.main.bounds.width / 4, UIScreen.main.bounds.height / 2)
    
    @Binding var reset: Bool
    
    var body: some View {
        ZStack {
            if sourceView {
                VStack(alignment: .leading, spacing: 4) {
                    Group {
                        Text("Rectangle").foregroundColor(.viewPink) +
                        Text("()")
                    }
                    .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    VStack(alignment: .leading, spacing: 4) {
                        ForegroundColorModifierCode(textSize: 24)
                        FrameModifierCode(textSize: 24)
                        if playgroundModel.brigthness != 0 {
                            BrightnessModifierCode(textSize: 24)
                        }
                        if playgroundModel.borderColor != .white || playgroundModel.borderWidth != 0 {
                            BorderModifierCode(textSize: 24)
                        }
                        if playgroundModel.cornerRadius != 0 {
                            CornerRadiusModifierCode(textSize: 24)
                        }
                        if playgroundModel.rotationEffect != 0 {
                            RotationEffectModifierCode(textSize: 24)
                        }
                        if playgroundModel.opacity != 1 {
                            OpacityModifierCode(textSize: 24)
                        }
                        if playgroundModel.scaleEffect != 1 {
                            ScaleEffectModifierCode(textSize: 24)
                        }
                        if playgroundModel.blurRadius != 0 {
                            BlurModifierCode(textSize: 24)
                        }
                        if playgroundModel.shadowColor != .white || playgroundModel.shadowRadius != 0 || playgroundModel.shadowX != 0 || playgroundModel.shadowY != 0 {
                            ShadowModifierCode(textSize: 24)
                        }
                    }
                    .padding(.leading, 32)
                }
            } else {
                Rectangle()
                    .foregroundColor(playgroundModel.foregroundColor)
                    .frame(width: playgroundModel.frameWidth, height: playgroundModel.frameHeight)
                    .brightness(playgroundModel.brigthness)
                    .border(playgroundModel.borderColor, width: playgroundModel.borderWidth)
                    .cornerRadius(playgroundModel.cornerRadius)
                    .rotationEffect(.degrees(playgroundModel.rotationEffect))
                    .opacity(playgroundModel.opacity)
                    .scaleEffect(playgroundModel.scaleEffect)
                    .blur(radius: playgroundModel.blurRadius)
                    .shadow(color: playgroundModel.shadowColor, radius: playgroundModel.shadowRadius, x: playgroundModel.shadowX, y: playgroundModel.shadowY)
                    .position(x: position.0, y: position.1)
                    .gesture(DragGesture().onChanged { value in
                        position.0 += value.translation.width - lastChange.0
                        position.1 += value.translation.height - lastChange.1
                        lastChange = (value.translation.width, value.translation.height)
                    }.onEnded { _ in
                        lastChange = (0, 0)
                    })
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height)
        .background(sourceView ? .black : .white)
        .overlay(alignment: .bottomTrailing) {
            Button {
                sourceView.toggle()
            } label: {
                Image(systemName: sourceView ? "eye" : "chevron.left.forwardslash.chevron.right")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background {
                        Circle()
                            .fill(.black)
                            .brightness(0.1)
                    }
            }
            .padding(32)
        }
        .onChange(of: reset) { newValue in
            if newValue {
                withAnimation(.spring()) {
                    position = (UIScreen.main.bounds.width / 4, UIScreen.main.bounds.height / 2)
                }
            }
        }
    }
}
