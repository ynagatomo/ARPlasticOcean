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
                Text("AR Plastic Ocean", comment: "App Name")
                    .font(.title)
                    .padding(4)

                // Usage
                ZStack { // TODO: rethink
                    RoundedRectangle(cornerRadius: 20.0)
                        .foregroundColor(Color("UsageBackgroundColor"))
                    UsageView()
                        .padding(16)
                        //    .background(Color("UsageBackgroundColor"),  // iOS 15.0+
                        //                in: RoundedRectangle(cornerRadius: 20.0))
                        .padding(.bottom, 16)
                }

                // Support
                ZStack { // TODO: rethink
                    RoundedRectangle(cornerRadius: 20.0)
                        .foregroundColor(Color("SupportBackgroundColor"))
                    SupportView()
                        .padding(16)
                    //    .background(Color("SupportBackgroundColor"), // iOS 15.0+
                    //                in: RoundedRectangle(cornerRadius: 20.0))
                        .padding(.bottom, 16)
                }

                // Explanation
                ZStack { // TODO: rethink
                    RoundedRectangle(cornerRadius: 20.0)
                        .foregroundColor(Color("ExplanationBackgroundColor"))
                    ExplanationView()
                        .padding(16)
                    //    .background(Color("ExplanationBackgroundColor"), // iOS 15.0+
                    //                in: RoundedRectangle(cornerRadius: 20.0))
                        .padding(.bottom, 16)
                }

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
            Text("usage", comment: "Usage title.")
                .font(.title2)
                .fontWeight(.bold)
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
        } // VStack
    }
}

struct SupportView: View {
    var body: some View {
        VStack {
            Text("support", comment: "Support title.")
                .font(.title2)
                .fontWeight(.bold)

            Text("please visit the support website to find the further information and updates about the app.",
                 comment: "")
                .padding(4)
            Link("support website", destination: URL(string: AppConstant.supportURLstring)!)
                .foregroundColor(.orange)
                .padding(4)
            Link("write a review", destination: URL(string: AppConstant.reviewURLstring)!)
                .foregroundColor(.orange)
                .padding(4)
        } // VStack
    }
}

struct ExplanationView: View {
    var body: some View {
        VStack {
            // TODO: replace the explanation with the final one
            Text("explanation", comment: "Explanation title.")
                .font(.title2)
                .fontWeight(.bold)

            Text("note explanation", comment: "Explanation about the plastic pollution.")
                .padding(4)

            HStack {
                Image("noteRefuses")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                Text("note refuses", comment: "Explanation about plastic refuses.")
            } // HStack

            HStack {
                Image("noteFish")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                Text("note lives", comment: "Explanation about damage to sea creatures.")
            } // HStack

            HStack {
                Image("noteRecycle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                Text("note recycle", comment: "Explanation about reduce, reuse, and recycle.")
            } // HStack
        } // VStack
    }
}
