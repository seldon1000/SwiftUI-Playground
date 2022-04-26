//
//  RotationEffectModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 12/04/22.
//

import SwiftUI

struct RotationEffectModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var isExpanded: Bool = false
    @State var secondaryRotationEffect: Double = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    private func resetAction() {
        withAnimation(.spring()) {
            playgroundModel.restoreRotationEffect()
        }
        
        selectedType = 0
        secondaryRotationEffect = 0
        selectedAnimationEasing = 0
        selectedAnimationDuration = 0
        selectedAnimationDelay = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                RotationEffectModifierCode(selectedType: $selectedType, isExpanded: $isExpanded, secondaryRotationEffect: $secondaryRotationEffect)
                    .padding()
                    .background {
                        Color.black
                            .cornerRadius(8)
                    }
                Spacer()
                AddModifierButton(isExpanded: $isExpanded, action: resetAction)
            }
            Text("Rotates this view’s rendered output around the specified point.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                Slider(value: $playgroundModel.rotationEffect, in: 0.0...360.0, step: 1, minimumValueLabel: Text(selectedType == 0 ? "Degrees: 0" : "Primary degrees: 0"), maximumValueLabel: Text("360")) {}
                if selectedType == 1 {
                    Slider(value: $secondaryRotationEffect, in: 0.0...360.0, step: 1, minimumValueLabel: Text("Secondary degrees: 0"), maximumValueLabel: Text("360")) {}
                    AnimationModifier {
                        playgroundModel.rotationEffect = secondaryRotationEffect
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

struct RotationEffectModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryRotationEffect: Double
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryRotationEffect: Binding<Double> = .constant(0), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryRotationEffect = secondaryRotationEffect
        self.textSize = textSize
    }
    
    var body: some View {
        Group {
            Text(".") +
            Text("rotationEffect").foregroundColor(.modifierPurple) +
            Text("(") +
            Text(isExpanded ? "\(playgroundModel.rotationEffect, specifier: "%.0f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
            Text(selectedType == 1 ? " -> " : "") +
            Text(selectedType == 1 ? "\(secondaryRotationEffect, specifier: "%.0f")" : "").foregroundColor(.valueYellow) +
            Text(")")
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
