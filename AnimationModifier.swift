//
//  AnimationModifier.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 19/04/22.
//

import SwiftUI

struct AnimationModifier: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @State var selectedAnimationEasing: Int = 0
    @State var selectedAnimationDuration: Double = 0
    @State var selectedAnimationDelay: Double = 0
    
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Slider(value: $selectedAnimationDuration, in: 0...10, step: 0.1, minimumValueLabel: Text("Duration: 0"), maximumValueLabel: Text("10")) {}
            Slider(value: $selectedAnimationDelay, in: 0...10, step: 0.1, minimumValueLabel: Text("Delay: 0"), maximumValueLabel: Text("10")) {}
            HStack {
                Text("Animation easing:")
                Picker("Animation easing", selection: $selectedAnimationEasing) {
                    Text("Linear").tag(0)
                    Text("EaseIn").tag(1)
                    Text("EaseOut").tag(2)
                    Text("EaseInOut").tag(3)
                }
                .pickerStyle(.segmented)
            }
            Button {
                let animation: Animation = {
                    switch selectedAnimationEasing {
                    case 0: return Animation.linear(duration: selectedAnimationDuration).delay(selectedAnimationDelay)
                    case 1: return Animation.easeIn(duration: selectedAnimationDuration).delay(selectedAnimationDelay)
                    case 2: return Animation.easeOut(duration: selectedAnimationDuration).delay(selectedAnimationDelay)
                    case 3: return Animation.easeInOut(duration: selectedAnimationDuration).delay(selectedAnimationDelay)
                    default: return Animation.default
                    }
                }()
                
                withAnimation(animation) {
                    action()
                }
            } label: {
                Text("PLAY")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .background {
                        Color.black
                            .brightness(0.2)
                            .cornerRadius(.infinity)
                    }
            }
        }
    }
}
