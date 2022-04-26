//
//  BrightnessModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 15/04/22.
//

import SwiftUI

struct BrightnessModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var isExpanded: Bool = false
    @State var secondaryBrightness: Double = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    private func resetAction() {
        withAnimation(.spring()) {
            playgroundModel.restoreBrightness()
        }
        
        selectedType = 0
        secondaryBrightness = 0
        selectedAnimationEasing = 0
        selectedAnimationDuration = 0
        selectedAnimationDelay = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                BrightnessModifierCode(selectedType: $selectedType, isExpanded: $isExpanded, secondaryBrightness: $secondaryBrightness)
                    .padding()
                    .background {
                        Color.black
                            .cornerRadius(8)
                    }
                Spacer()
                AddModifierButton(isExpanded: $isExpanded, action: resetAction)
            }
            Text("Brightens this view by the specified amount.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                Slider(value: $playgroundModel.brigthness, in: -1...1, step: 0.1, minimumValueLabel: Text(selectedType == 0 ? "Brightness: -1" : "Primary brightness: -1"), maximumValueLabel: Text("1")) {}
                if selectedType == 1 {
                    Slider(value: $secondaryBrightness, in: -1...1, step: 0.1, minimumValueLabel: Text("Secondary brightness: -1"), maximumValueLabel: Text("1")) {}
                    AnimationModifier {
                        playgroundModel.brigthness = secondaryBrightness
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

struct BrightnessModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryBrightness: Double
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryBrightness: Binding<Double> = .constant(1), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryBrightness = secondaryBrightness
        self.textSize = textSize
    }
    
    var body: some View {
        Group {
            Text(".") +
            Text("brightness").foregroundColor(.modifierPurple) +
            Text("(") +
            Text(isExpanded ? "\(playgroundModel.brigthness, specifier: "%.1f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
            Text(selectedType == 1 ? " -> " : "") +
            Text(selectedType == 1 ? "\(secondaryBrightness, specifier: "%.1f")" : "").foregroundColor(.valueYellow) +
            Text(")")
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
