//
//  ButtonStyle.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/01.
//

//    import SwiftUI
//
//    struct RoundedRectangleFill: View {
//        var cornerRadius: CGFloat
//        var fillColor: Color
//        var body: some View {
//            return RoundedRectangle(cornerRadius: cornerRadius)
//                .foregroundColor(fillColor)
//        }
//    }
//
//    struct CustomButtonStyle: ButtonStyle {
//        @State var isEnabled: Bool
//        var cornerRadius: CGFloat
//        var color: Color
//        var disabledColor: Color
//        var textColor: Color
//
//        func makeBody(configuration: Configuration) -> some View {
//            let isPressed = configuration.isPressed
//            let foregroundColor = isEnabled ? color : disabledColor
//            return configuration.label
//                .background(RoundedRectangleFill.init(cornerRadius: cornerRadius, fillColor: foregroundColor))
//                .foregroundColor(textColor)
//    //                .shadow(color: foregroundColor, radius: 5, x: 0, y: 0)
//                .scaleEffect(x: isPressed ? 0.95 : 1, y: isPressed ? 0.95 : 1, anchor: .center)
//                .animation(.spring(response: 0.2, dampingFraction: 0.9, blendDuration: 0))
//        }
//    }
