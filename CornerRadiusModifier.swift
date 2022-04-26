//
//  CornerRadiusModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 12/04/22.
//

import SwiftUI

struct CornerRadiusModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var isExpanded: Bool = false
    @State var secondaryCornerRadius: Double = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    private func resetAction() {
        withAnimation(.spring()) {
            playgroundModel.restoreCornerRadius()
        }
        
        selectedType = 0
        selectedType = 0
        secondaryCornerRadius = 0
        selectedAnimationEasing = 0
        selectedAnimationDuration = 0
        selectedAnimationDelay = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                CornerRadiusModifierCode(selectedType: $selectedType, isExpanded: $isExpanded, secondaryCornerRadius: $secondaryCornerRadius)
                    .padding()
                    .background {
                        Color.black
                            .cornerRadius(8)
                    }
                Spacer()
                AddModifierButton(isExpanded: $isExpanded, action: resetAction)
            }
            Text("Clips this view to its bounding frame, with the specified corner radius.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                Slider(value: $playgroundModel.cornerRadius, in: 0...((playgroundModel.frameWidth < playgroundModel.frameHeight ? playgroundModel.frameWidth + 2 : playgroundModel.frameHeight + 2) / 2), step: 1) {
                    
                } minimumValueLabel: {
                    Text(selectedType == 0 ? "Corner radius: 0" : "Primary corner radius: 0")
                } maximumValueLabel: {
                    Text("∞")
                }
                if selectedType == 1 {
                    Slider(value: $secondaryCornerRadius, in: 0...((playgroundModel.frameWidth < playgroundModel.frameHeight ? playgroundModel.frameWidth : playgroundModel.frameHeight) / 2), step: 1) {
                        
                    } minimumValueLabel: {
                        Text("Secondary corner radius: 0")
                    } maximumValueLabel: {
                        Text("∞")
                    }
                    AnimationModifier {
                        playgroundModel.cornerRadius = secondaryCornerRadius
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

struct CornerRadiusModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryCornerRadius: Double
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryCornerRadius: Binding<Double> = .constant(0), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryCornerRadius = secondaryCornerRadius
        self.textSize = textSize
    }
    
    var body: some View {
        Group {
            Text(".") +
            Text("cornerRadius").foregroundColor(.modifierPurple) +
            Text("(") +
            Text(isExpanded ? "\(playgroundModel.cornerRadius, specifier: "%.0f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
            Text(selectedType == 1 ? " -> " : "") +
            Text(selectedType == 1 ? "\(secondaryCornerRadius, specifier: "%.0f")" : "").foregroundColor(.valueYellow) +
            Text(")")
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
