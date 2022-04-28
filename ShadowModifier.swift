//
//  ShadowModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 13/04/22.
//

import SwiftUI

struct ShadowModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var isExpanded: Bool = false
    @State var secondaryShadowColor: Color = .white
    @State var secondaryShadowRadius: Double = 0
    @State var secondaryShadowX: CGFloat = 0
    @State var secondaryShadowY: CGFloat = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    private func resetAction() {
        withAnimation(.spring()) {
            playgroundModel.restoreShadow()
        }
        
        selectedType = 0
        secondaryShadowColor = .white
        secondaryShadowRadius = 0
        secondaryShadowX = 0
        secondaryShadowY = 0
        selectedAnimationEasing = 0
        selectedAnimationDuration = 0
        selectedAnimationDelay = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 0) {
                ShadowModifierCode(selectedType: $selectedType, isExpanded: $isExpanded, secondaryShadowColor: $secondaryShadowColor, secondaryShadowRadius: $secondaryShadowRadius, secondaryShadowX: $secondaryShadowX, secondaryShadowY: $secondaryShadowY)
                    .padding()
                    .background {
                        Color.black
                            .cornerRadius(8)
                    }
                Spacer()
                AddModifierButton(isExpanded: $isExpanded, action: resetAction)
            }
            Text("Adds a shadow to this view.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                ColorPicker(selection: $playgroundModel.shadowColor) {
                    Text(selectedType == 0 ? "Color:" : "Primary color:")
                }
                Slider(value: $playgroundModel.shadowRadius, in: 0.0...64.0, step: 1, minimumValueLabel: Text(selectedType == 0 ? "Radius: 0" : "Primary radius: 0"), maximumValueLabel: Text("64")) {}
                Stepper {
                    Text(selectedType == 0 ? "Horizontal offset:" : "Primary horizontal offset")
                } onIncrement: {
                    playgroundModel.shadowX += 10
                } onDecrement: {
                    playgroundModel.shadowX -= 10
                }
                Stepper {
                    Text(selectedType == 0 ? "Vertical offset:" : "Primary vertical offset")
                } onIncrement: {
                    playgroundModel.shadowY += 10
                } onDecrement: {
                    playgroundModel.shadowY -= 10
                }
                if selectedType == 1 {
                    ColorPicker(selection: $secondaryShadowColor) {
                        Text("Secondary color:")
                    }
                    Slider(value: $secondaryShadowRadius, in: 0.0...64.0, step: 1, minimumValueLabel: Text("Secondary radius: 0"), maximumValueLabel: Text("64")) {}
                    Stepper {
                        Text("Secondary horizontal offset")
                    } onIncrement: {
                        secondaryShadowX += 10
                    } onDecrement: {
                        secondaryShadowX -= 10
                    }
                    Stepper {
                        Text("Secondary vertical offset")
                    } onIncrement: {
                        secondaryShadowY += 10
                    } onDecrement: {
                        secondaryShadowY -= 10
                    }
                    AnimationModifier {
                        playgroundModel.shadowColor = secondaryShadowColor
                        playgroundModel.shadowRadius = secondaryShadowRadius
                        playgroundModel.shadowX = secondaryShadowX
                        playgroundModel.shadowY = secondaryShadowY
                    }
                }
            }
            .allowsHitTesting(isExpanded)
            .padding([.horizontal, .bottom])
            .frame(maxHeight: isExpanded ? .none : 0)
            .clipped()
        }
        .background {
            Color.black
                .brightness(0.1)
                .cornerRadius(8)
        }
        .onChange(of: reset) { newValue in
            if newValue {
                withAnimation(.easeInOut) {
                    isExpanded = false
                }
                
                resetAction()
            }
        }
    }
}

struct ShadowModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryShadowColor: Color
    @Binding var secondaryShadowRadius: Double
    @Binding var secondaryShadowX: CGFloat
    @Binding var secondaryShadowY: CGFloat
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryShadowColor: Binding<Color> = .constant(.white), secondaryShadowRadius: Binding<Double> = .constant(0), secondaryShadowX: Binding<CGFloat> = .constant(0), secondaryShadowY: Binding<CGFloat> = .constant(0), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryShadowColor = secondaryShadowColor
        _secondaryShadowRadius = secondaryShadowRadius
        _secondaryShadowX = secondaryShadowX
        _secondaryShadowY = secondaryShadowY
        self.textSize = textSize
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                Text(".") +
                Text("shadow").foregroundColor(.modifierPurple) +
                Text("(") +
                Text("color").foregroundColor(.modifierPurple) +
                Text(": ") +
                Text("\(Image(systemName: "rectangle.fill"))").foregroundColor(playgroundModel.shadowColor) +
                Text(selectedType == 1 ? " -> " : "") +
                Text(selectedType == 1 ? "\(Image(systemName: "rectangle.fill"))" : "").foregroundColor(secondaryShadowColor) +
                Text(", ") +
                Text("radius").foregroundColor(.modifierPurple)
            }
            .lineLimit(1)
            Group {
                Text(": ") +
                Text(isExpanded ? "\(playgroundModel.shadowRadius, specifier: "%.0f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
                Text(selectedType == 1 ? " -> " : "") +
                Text(selectedType == 1 ? "\(secondaryShadowRadius, specifier: "%.0f")" : "").foregroundColor(.valueYellow) +
                Text(", ") +
                Text("x").foregroundColor(.modifierPurple) +
                Text(": ") +
                Text(isExpanded ? "\(playgroundModel.shadowX, specifier: "%.0f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
                Text(selectedType == 1 ? " -> " : "") +
                Text(selectedType == 1 ? "\(secondaryShadowX, specifier: "%.0f")" : "").foregroundColor(.valueYellow)
            }
            .lineLimit(1)
            Group {
                Text(", ") +
                Text("y").foregroundColor(.modifierPurple) +
                Text(": ") +
                Text(isExpanded ? "\(playgroundModel.shadowY, specifier: "%.0f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
                Text(selectedType == 1 ? " -> " : "") +
                Text(selectedType == 1 ? "\(secondaryShadowY, specifier: "%.0f")" : "").foregroundColor(.valueYellow) +
                Text(")")
            }
            .lineLimit(1)
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
