import SwiftUI

struct ContentView: View {
    @State var playgroundModel: PlaygroundModel = PlaygroundModel()
    @State var reset: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Playground(reset: $reset)
            VStack(spacing: 0) {
                ModifiersHeader(reset: $reset)
                    .padding()
                ScrollView {
                    VStack(spacing: 16) {
                        FrameModifier(reset: $reset)
                        ForegroundColorModifier(reset: $reset)
                        OpacityModifier(reset: $reset)
                        ScaleEffectModifier(reset: $reset)
                        RotationEffectModifier(reset: $reset)
                        CornerRadiusModifier(reset: $reset)
                        ShadowModifier(reset: $reset)
                        BorderModifier(reset: $reset)
                        BrightnessModifier(reset: $reset)
                        BlurModifier(reset: $reset)
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .frame(height: UIScreen.main.bounds.height)
            .background {
                Color.black
                    .brightness(0.15)
            }
        }
        .environmentObject(playgroundModel)
        .ignoresSafeArea()
    }
}

extension Color {
    static let modifierPurple: Color = Color("modifierColor")
    static let valueYellow: Color = Color("valueColor")
    static let viewPink: Color = Color("viewPink")
}
