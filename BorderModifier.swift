//
//  BorderModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 15/04/22.
//

import SwiftUI

struct BorderModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var isExpanded: Bool = false
    @State var secondaryColor: Color = .white
    @State var secondaryWidth: CGFloat = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    private func resetAction() {
        withAnimation(.spring()) {
            playgroundModel.restoreBorder()
        }
        
        selectedType = 0
        secondaryColor = .white
        secondaryWidth = 0
        selectedAnimationEasing = 0
        selectedAnimationDuration = 0
        selectedAnimationDelay = 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 0) {
                BorderModifierCode(selectedType: $selectedType, isExpanded: $isExpanded, secondaryBorderColor: $secondaryColor, secondaryBorderWidth: $secondaryWidth)
                    .padding()
                    .background {
                        Color.black
                            .cornerRadius(8)
                    }
                Spacer()
                AddModifierButton(isExpanded: $isExpanded, action: resetAction)
            }
            Text("Adds a border to this view with the specified style and width.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                HStack(spacing: 24) {
                    ColorPicker(selection: $playgroundModel.borderColor) {
                        Text(selectedType == 0 ? "Color:" : "Primary color:")
                    }
                    .frame(maxWidth: .infinity)
                    Stepper {
                        Text(selectedType == 0 ? "Width:" : "Primary width:")
                    } onIncrement: {
                        withAnimation(.easeInOut) {
                            playgroundModel.borderWidth += 1
                        }
                    } onDecrement: {
                        withAnimation(.easeInOut) {
                            playgroundModel.borderWidth -= 1
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                if selectedType == 1 {
                    HStack(spacing: 24) {
                        ColorPicker(selection: $secondaryColor) {
                            Text("Secondary color:")
                        }
                        .frame(maxWidth: .infinity)
                        Stepper {
                            Text("Secondary width:")
                        } onIncrement: {
                            withAnimation(.easeInOut) {
                                secondaryWidth += 1
                            }
                        } onDecrement: {
                            withAnimation(.easeInOut) {
                                secondaryWidth -= 1
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    AnimationModifier {
                        playgroundModel.borderColor = secondaryColor
                        playgroundModel.borderWidth = secondaryWidth
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

struct BorderModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryBorderColor: Color
    @Binding var secondaryBorderWidth: CGFloat
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryBorderColor: Binding<Color> = .constant(.white), secondaryBorderWidth: Binding<CGFloat> = .constant(0), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryBorderColor = secondaryBorderColor
        _secondaryBorderWidth = secondaryBorderWidth
        self.textSize = textSize
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                Text(".") +
                Text("border").foregroundColor(.modifierPurple) +
                Text("(") +
                Text("\(Image(systemName: "rectangle.fill"))").foregroundColor(playgroundModel.borderColor) +
                Text(selectedType == 1 ? " -> " : "") +
                Text(selectedType == 1 ? "\(Image(systemName: "rectangle.fill"))" : "").foregroundColor(secondaryBorderColor) +
                Text(", ")
            }
            .lineLimit(1)
            Group {
                Text("width").foregroundColor(.modifierPurple) +
                Text(": ") +
                Text(isExpanded ? "\(playgroundModel.borderWidth, specifier: "%.0f")" : "\(Image(systemName: "rectangle.fill"))").foregroundColor(.valueYellow) +
                Text(selectedType == 1 ? " -> " : "")
                Text(selectedType == 1 ? "\(secondaryBorderWidth, specifier: "%.0f")" : "").foregroundColor(.valueYellow) +
                Text(")")
            }
            .lineLimit(1)
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
