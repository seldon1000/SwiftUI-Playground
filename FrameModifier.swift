//
//  FrameModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 15/04/22.
//

import SwiftUI

struct FrameModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedType: Int = 0
    @State var secondaryFrameWidth: CGFloat = 0
    @State var secondaryFrameHeight: CGFloat = 0
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    @Binding var reset: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            FrameModifierCode(selectedType: $selectedType, secondaryFrameWidth: $secondaryFrameWidth, secondaryFrameHeight: $secondaryFrameHeight)
                .padding()
                .background {
                    Color.black
                        .cornerRadius(8)
                }
            Text("Positions this view within an invisible frame with the specified size.")
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 16) {
                Picker("", selection: $selectedType) {
                    Text("Static").tag(0)
                    Text("Animated").tag(1)
                }
                .pickerStyle(.segmented)
                Slider(value: $playgroundModel.frameWidth, in: 0...256, step: 1, minimumValueLabel: Text(selectedType == 0 ? "Width: 0" : "Primary width: 0"), maximumValueLabel: Text("256")) {}
                Slider(value: $playgroundModel.frameHeight, in: 0...256, step: 1, minimumValueLabel: Text(selectedType == 0 ? "Height: 0" : "Primary height: 0"), maximumValueLabel: Text("256")) {}
                if selectedType == 1 {
                    Slider(value: $secondaryFrameWidth, in: 0...256, step: 1, minimumValueLabel: Text(selectedType == 0 ? "Width: 0" : "Secondary width: 0"), maximumValueLabel: Text("256")) {}
                    Slider(value: $secondaryFrameHeight, in: 0...256, step: 1, minimumValueLabel: Text(selectedType == 0 ? "Height: 0" : "Secondary height: 0"), maximumValueLabel: Text("256")) {}
                    AnimationModifier {
                        playgroundModel.frameWidth = secondaryFrameWidth
                        playgroundModel.frameHeight = secondaryFrameHeight
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
                playgroundModel.restoreFrame()
                
                selectedType = 0
                secondaryFrameWidth = 0
                secondaryFrameHeight = 0
                selectedAnimationEasing = 0
                selectedAnimationDuration = 0
                selectedAnimationDelay = 0
            }
        }
    }
}

struct FrameModifierCode: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var selectedType: Int
    @Binding var isExpanded: Bool
    @Binding var secondaryFrameWidth: CGFloat
    @Binding var secondaryFrameHeight: CGFloat
    
    let textSize: CGFloat
    
    init(selectedType: Binding<Int> = .constant(0), isExpanded: Binding<Bool> = .constant(true), secondaryFrameWidth: Binding<CGFloat> = .constant(128), secondaryFrameHeight: Binding<CGFloat> = .constant(0), textSize: CGFloat = 18) {
        _selectedType = selectedType
        _isExpanded = isExpanded
        _secondaryFrameWidth = secondaryFrameWidth
        _secondaryFrameHeight = secondaryFrameHeight
        self.textSize = textSize
    }
    
    var body: some View {
        HStack (spacing: 0) {
            Group {
                Text(".") +
                Text("frame").foregroundColor(.modifierPurple) +
                Text("(") +
                Text("width").foregroundColor(.modifierPurple) +
                Text(": ") +
                Text("\(playgroundModel.frameWidth, specifier: "%.0f")").foregroundColor(.valueYellow) +
                Text(selectedType == 1 ? " -> " : "") +
                Text(selectedType == 1 ? "\(secondaryFrameWidth, specifier: "%.0f")" : "").foregroundColor(.valueYellow) +
                Text(", ")
            }
            Group {
                Text("height").foregroundColor(.modifierPurple) +
                Text(": ") +
                Text("\(playgroundModel.frameHeight, specifier: "%.0f")").foregroundColor(.valueYellow) +
                Text(selectedType == 1 ? " -> " : "") +
                Text(selectedType == 1 ? "\(secondaryFrameHeight, specifier: "%.0f")" : "").foregroundColor(.valueYellow) +
                Text(")")
            }
        }
        .font(.system(size: textSize, weight: .semibold, design: .monospaced))
    }
}
