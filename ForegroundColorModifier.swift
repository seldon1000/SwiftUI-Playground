//
//  ForegroundColorModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 15/04/22.
//

import SwiftUI

struct ForegroundColorModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var secondaryForegroundColor: Color = .white
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForegroundColorModifierCode(selectedType: $selectedType, secondaryForegroundColor: $secondaryForegroundColor)
                .padding()
                .background {
                    Color.black
                        .cornerRadius(8)
                }
            Text("Sets the color of the foreground elements displayed by this view.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 24) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                if selectedType == 0 {
                    ColorPicker(selection: $playgroundModel.foregroundColor) {
                        Text("Color:")
                    }
                } else {
                    HStack(spacing: 24) {
                        ColorPicker(selection: $playgroundModel.foregroundColor) {
                            Text("Primary color:")
                        }
                        ColorPicker(selection: $secondaryForegroundColor) {
                            Text("Secondary color:")
                        }
                    }
                    AnimationModifier {
                        playgroundModel.foregroundColor = secondaryForegroundColor
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background {
            Color.black
                .brightness(0.1)
                .cornerRadius(8)
        }
        .onChange(of: reset) { newValue in
            if newValue {
                withAnimation(.spring()) {
                    playgroundModel.restoreForegroundColor()
                }
                
                selectedType = 0
                secondaryForegroundColor = .white
                selectedAnimationEasing = 0
                selectedAnimationDuration = 0
                selectedAnimationDelay = 0
            }
        }
    }
}

struct ForegroundColorModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryForegroundColor: Color
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryForegroundColor: Binding<Color> = .constant(.white), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryForegroundColor = secondaryForegroundColor
        self.textSize = textSize
    }
    
    var body: some View {
        Group {
            Text(".") +
            Text("foregroundColor").foregroundColor(.modifierPurple) +
            Text("(") +
            Text("\(Image(systemName: "rectangle.fill"))").foregroundColor(playgroundModel.foregroundColor) +
            Text(selectedType == 1 ? " -> " : "") +
            Text(selectedType == 1 ? "\(Image(systemName: "rectangle.fill"))" : "").foregroundColor(secondaryForegroundColor) +
            Text(")")
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
