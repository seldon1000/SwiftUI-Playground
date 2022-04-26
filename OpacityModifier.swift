//
//  OpacityModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 12/04/22.
//

import SwiftUI

struct OpacityModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var isExpanded: Bool = false
    @State var secondaryOpacity: Double = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    private func resetAction() {
        withAnimation(.spring()) {
            playgroundModel.restoreOpacity()
        }
        
        selectedType = 0
        secondaryOpacity = 0
        selectedAnimationEasing = 0
        selectedAnimationDuration = 0
        selectedAnimationDelay = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                OpacityModifierCode(selectedType: $selectedType, isExpanded: $isExpanded, secondaryOpacity: $secondaryOpacity)
                    .padding()
                    .background {
                        Color.black
                            .cornerRadius(8)
                    }
                Spacer()
                AddModifierButton(isExpanded: $isExpanded, action: resetAction)
            }
            Text("Sets the transparency of this view.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                Slider(value: $playgroundModel.opacity, in: 0.0...1.0, step: 0.1, minimumValueLabel: Text(selectedType == 0 ? "Opacity: 0.0" : "Primary opacity: 0.0"), maximumValueLabel: Text("1.0")) {}
                if selectedType == 1 {
                    Slider(value: $secondaryOpacity, in: 0.0...1.0, step: 0.1, minimumValueLabel: Text("Secondary opacity: 0.0"), maximumValueLabel: Text("1.0")) {}
                    AnimationModifier {
                        playgroundModel.opacity = secondaryOpacity
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

struct OpacityModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryOpacity: Double
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryOpacity: Binding<Double> = .constant(1), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryOpacity = secondaryOpacity
        self.textSize = textSize
    }
    
    var body: some View {
        Group {
            Text(".") +
            Text("opacity").foregroundColor(.modifierPurple) +
            Text("(") +
            Text(isExpanded ? "\(playgroundModel.opacity, specifier: "%.1f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
            Text(selectedType == 1 ? " -> " : "") +
            Text(selectedType == 1 ? "\(secondaryOpacity, specifier: "%.1f")" : "").foregroundColor(.valueYellow) +
            Text(")")
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
