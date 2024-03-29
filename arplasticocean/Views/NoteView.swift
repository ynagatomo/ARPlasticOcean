//
//  NoteView.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import SwiftUI

struct NoteView: View {
    //     @Environment(\.dismiss) private var dismiss  // iOS 15.0+
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color("NoteBackgroundColor") // background color

            ScrollView(.vertical, showsIndicators: false) {
                // Top Bar
                HStack {
                    Button(action: dismiss) { //  dismiss.callAsFunction) { // iOS 15.0+
                        Image(systemName: "xmark.circle")
                            .font(.title)
                            .padding(10)
                    }
                    // .tint(.yellow) // iOS 15.0+
                    Spacer()
                } // HStack

                // Title
                Text(Bundle.main.appName)
                    .font(.title.bold())
                    .padding(8)
                HStack {
                    Text(String("Ver. \(Bundle.main.appVersion)"))
                        .padding(.bottom, 8)
                }

                // Usage
                UsageView()
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                            .foregroundColor(Color("UsageBackgroundColor"))
                    )
                    //    .background(Color("UsageBackgroundColor"),  // iOS 15.0+
                    //                in: RoundedRectangle(cornerRadius: 20.0))
                    .padding(.bottom, 16)

                // Support
                SupportView()
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                            .foregroundColor(Color("SupportBackgroundColor"))
                    )
                    //    .background(Color("SupportBackgroundColor"), // iOS 15.0+
                    //                in: RoundedRectangle(cornerRadius: 20.0))
                    .padding(.bottom, 16)

                // Explanation
                ExplanationView()
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                            .foregroundColor(Color("ExplanationBackgroundColor"))
                    )
                    //    .background(Color("ExplanationBackgroundColor"), // iOS 15.0+
                    //                in: RoundedRectangle(cornerRadius: 20.0))
                    .padding(.bottom, 16)

                Text(String("Music: (C) HURT RECORD"))
            } // ScrollView
            .foregroundColor(.white)
            .padding()
        } // ZStack
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15, *) {
            NoteView()
            .previewInterfaceOrientation(.portrait)
            NoteView()
            .previewInterfaceOrientation(.landscapeRight)
        } else {
            NoteView()
        }
    }
}

struct UsageView: View {
    var body: some View {
        VStack {
            Text("usage", comment: "Usage: title.")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                Image(systemName: "iphone.landscape")
                    .font(.largeTitle)
                Text("hold your iPhone / iPad in front of your chest and press the start button.",
                     comment: "Usage: How to begin.")
            }
            .padding(4)
            HStack {
                Image(systemName: "hand.tap.fill")
                    .font(.largeTitle)
                Text("tap the plastic refuses to collect them.",
                     comment: "Usage: How to collect refuses.")
            }
            .padding(4)
        } // VStack
    }
}

struct SupportView: View {
    var body: some View {
        VStack {
            Text("support", comment: "Support: title.")
                .font(.title2)
                .fontWeight(.bold)
            Link("support website", destination: URL(string: AppConstant.supportURLstring)!)
                .foregroundColor(.orange)
                .padding(4)
            Link("write a review", destination: URL(string: AppConstant.reviewURLstring)!)
                .foregroundColor(.orange)
                .padding(4)
            Link(String("Twitter: @ARPlasticOcean"), destination: URL(string: AppConstant.twitterURLstring)!)
                .foregroundColor(.orange)
                .padding(4)
        } // VStack
    }
}

struct ExplanationView: View {
    var body: some View {
        VStack {
            Text("plastic ocean", comment: "Plastic Ocean: title.")
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                Image("noteRefuses")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                Text("note refuses", comment: "Note: plastic refuses.")
            } // HStack

            HStack {
                Image("noteFish")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                Text("note lives", comment: "Note: damage to sea creatures.")
            } // HStack

            HStack {
                Image("noteRecycle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                Text("note recycle", comment: "Note: reduce, reuse, and recycle.")
            } // HStack
        } // VStack
    }
}
