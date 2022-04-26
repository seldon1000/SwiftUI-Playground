//
//  AddModifierButton.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 20/04/22.
//

import SwiftUI

struct AddModifierButton: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    
    @Binding var isExpanded: Bool
    
    let action: () -> Void
    
    var body: some View {
        Button {
            if isExpanded {
                action()
            }
            
            withAnimation(.easeInOut) {
                isExpanded.toggle()
            }
        } label: {
            Image(systemName: isExpanded ? "minus" : "plus")
                .font(.system(size: 18, weight: .semibold, design: .monospaced))
                .foregroundColor(.white)
                .frame(maxHeight: .infinity)
                .padding()
                .background {
                    Rectangle()
                        .cornerRadius(8)
                        .foregroundColor(isExpanded ? .red : .blue)
                }
        }
    }
}
