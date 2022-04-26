//
//  BlurModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 15/04/22.
//

import SwiftUI

struct BlurModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var isExpanded: Bool = false
    @State var secondaryBlurRadius: CGFloat = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    private func resetAction() {
        withAnimation(.spring()) {
            playgroundModel.restoreBlur()
        }
        
        selectedType = 0
        secondaryBlurRadius = 0
        selectedAnimationEasing = 0
        selectedAnimationDuration = 0
        selectedAnimationDelay = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                BlurModifierCode(selectedType: $selectedType, isExpanded: $isExpanded, secondaryBlurRadius: $secondaryBlurRadius)
                    .padding()
                    .background {
                        Color.black
                            .cornerRadius(8)
                    }
                Spacer()
                AddModifierButton(isExpanded: $isExpanded, action: resetAction)
            }
            Text("Applies a Gaussian blur to this view.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                Slider(value: $playgroundModel.blurRadius, in: 0...64, step: 1, minimumValueLabel: Text(selectedType == 0 ? "Radius: 0" : "Primary radius: 0"), maximumValueLabel: Text("64")) {}
                if selectedType == 1 {
                    Slider(value: $secondaryBlurRadius, in: 0...64, step: 1, minimumValueLabel: Text("Secondary radius: 0"), maximumValueLabel: Text("64")) {}
                    AnimationModifier {
                        playgroundModel.blurRadius = secondaryBlurRadius
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

struct BlurModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryBlurRadius: CGFloat
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryBlurRadius: Binding<CGFloat> = .constant(0), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryBlurRadius = secondaryBlurRadius
        self.textSize = textSize
    }
    
    var body: some View {
        Group {
            Text(".") +
            Text("blur").foregroundColor(.modifierPurple) +
            Text("(") +
            Text("radius").foregroundColor(.modifierPurple) +
            Text(": ") +
            Text(isExpanded ? "\(playgroundModel.blurRadius, specifier: "%.0f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
            Text(selectedType == 1 ? " -> " : "") +
            Text(selectedType == 1 ? "\(secondaryBlurRadius, specifier: "%.0f")" : "").foregroundColor(.valueYellow) +
            Text(")")
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
