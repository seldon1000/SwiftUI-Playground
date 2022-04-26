//
//  ScaleEffectModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 12/04/22.
//

import SwiftUI

struct ScaleEffectModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var isExpanded: Bool = false
    @State var secondaryScaleEffect: Double = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    private func resetAction() {
        withAnimation(.spring()) {
            playgroundModel.restoreScaleEffect()
        }
        
        selectedType = 0
        secondaryScaleEffect = 0
        selectedAnimationEasing = 0
        selectedAnimationDuration = 0
        selectedAnimationDelay = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                ScaleEffectModifierCode(selectedType: $selectedType, isExpanded: $isExpanded, secondaryScaleEffect: $secondaryScaleEffect)
                    .padding()
                    .background {
                        Color.black
                            .cornerRadius(8)
                    }
                Spacer()
                AddModifierButton(isExpanded: $isExpanded, action: resetAction)
            }
            Text("Scales this view’s rendered output by the given amount in both the horizontal and vertical directions, relative to an anchor point.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                Slider(value: $playgroundModel.scaleEffect, in: 0.0...2.0, step: 0.1, minimumValueLabel: Text(selectedType == 0 ? "Scale effect: 0.0" : "Primary scale effect: 0.0"), maximumValueLabel: Text("2.0")) {}
                if selectedType == 1 {
                    Slider(value: $secondaryScaleEffect, in: 0.0...2.0, step: 0.1, minimumValueLabel: Text("Secondary scale effect: 0.0"), maximumValueLabel: Text("2.0")) {}
                    AnimationModifier {
                        playgroundModel.scaleEffect = secondaryScaleEffect
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

struct ScaleEffectModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryScaleEffect: Double
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryScaleEffect: Binding<Double> = .constant(1), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryScaleEffect = secondaryScaleEffect
        self.textSize = textSize
    }
    
    var body: some View {
        Group {
            Text(".") +
            Text("scaleEffect").foregroundColor(.modifierPurple) +
            Text("(") +
            Text(isExpanded ? "\(playgroundModel.scaleEffect, specifier: "%.1f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
            Text(selectedType == 1 ? " -> " : "") +
            Text(selectedType == 1 ? "\(secondaryScaleEffect, specifier: "%.1f")" : "").foregroundColor(.valueYellow) +
            Text(")")
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
