//
//  NoteView.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.brown) // background color

            ScrollView(.vertical, showsIndicators: false) {
                // Top Bar
                HStack {
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "xmark.circle")
                            .font(.title)
                            .padding(10)
                    }
                    .tint(.yellow)
                    Spacer()
                } // HStack

                // Title
                Text("AR Plastic Ocean", comment: "App Name")
                    .font(.title)
                    .padding(4)

                // Usage
                Text("usage", comment: "Usage title.")
                    .font(.title2)

                HStack {
                    Image(systemName: "hand.tap.fill")
                        .font(.largeTitle)
                    Text("Tap the plastic refuses to collect them.",
                         comment: "How to collect refuses.")
                }
                .padding(4)

                HStack {
                    Image(systemName: "iphone.landscape")
                        .font(.largeTitle)
                    Text("Hold your iPhone / iPad in front of your chest and press the start button.",
                         comment: "How to begin.")
                }
                .padding(4)

                // Support
                Text("support", comment: "Support title.")
                    .font(.title2)
                    .padding(16)
                Link("support website", destination: URL(string: AppConstant.supportURLstring)!)
                    .padding(4)
                Link("write a review", destination: URL(string: AppConstant.reviewURLstring)!)
                    .padding(4)

                // Explanation
                // TODO: replace the explanation with the final one
                Text("explanation", comment: "Explanation title.")
                    .font(.title2)
                    .padding(16)
                Text("(dummy) explanation...", comment: "(dummy) Explanation...")
                    .padding(4)

            } // ScrollView
            .foregroundColor(.white)
            .padding()
        } // ZStack
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}
