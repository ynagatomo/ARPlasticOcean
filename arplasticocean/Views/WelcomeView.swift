//
//  WelcomeView.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/07.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingAgain: Bool

    var body: some View {
        ScrollView(showsIndicators: false) {
            Text(Bundle.main.appName)
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            HStack {
                Image("noteFish")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                Text("save the ocean lives.", comment: "Guide: message")
            } // HStack

            UsageView()
                .padding(.bottom, 24)

            Text("continue")
                .font(.title2)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .onTapGesture {
                    close()
                }

            Button(action: { showingAgain.toggle() }, label: {
                HStack {
                    Image(systemName: showingAgain ? "square" : "checkmark.square")
                    Text("not show again")
                }
                .foregroundColor(Color.orange)
            }).padding()
        }
        .padding(64)
    }

    private func close() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15, *) {
            WelcomeView(showingAgain: .constant(true))
            .previewInterfaceOrientation(.portrait)
            WelcomeView(showingAgain: .constant(true))
            .previewInterfaceOrientation(.landscapeRight)
        } else {
            WelcomeView(showingAgain: .constant(true))
        }
    }
}
