//
//  ModifiersHeader.swift
//  NCSE-2
//
//  Created by Nicolas Mariniello on 12/04/22.
//

import SwiftUI

struct ModifiersHeader: View {
    @Binding var reset: Bool
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    reset = true
                }
                
                reset = false
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(reset ? 180 : 0))
            }
            Spacer()
            Text("Modifiers")
                .font(.system(size: 22, weight: .semibold))
            Spacer()
        }
        .padding()
    }
}
