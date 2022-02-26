//
//  HomeView.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import SwiftUI
import AVFoundation
import StoreKit

struct HomeView: View {
    @EnvironmentObject var appStateController: AppStateController
    @State private var showingNoteView = false
    @State private var showingOceanView = false
    @State private var showingDevView = false
    @State private var showingMedalApproval = false

    @State private var medal: CleanupMedal?

    // swiftlint:disable force_try
    private let medalSoundPlayer = try! AVAudioPlayer(
        contentsOf: Bundle.main.url(forResource: AppConstant.soundMedalName,
                                    withExtension: AppConstant.soundMedalExt)!)

    var body: some View {
        VStack {
            // Top Bar
            HStack {
                // Note Button
                Button(action: {
                    showingNoteView = true
                }, label: {
                    Image(systemName: "info.circle.fill") // "doc.plaintext.fill")
                })
                Spacer()

                // Dev Button
                #if DEBUG
                Button(action: {
                    showingDevView = true
                }, label: {
                    Image(systemName: "gear")
                })
                #endif

                // Sound Button
                Toggle(isOn: $appStateController.isSoundEnable) {
                    Image(systemName: "speaker.wave.2.fill")
                }
                .toggleStyle(.button)
            } // HStack (Top Bar)
            .font(.title2)
            Spacer()

            // Content
            ContentView(cleanupCount: appStateController.cleanupCount,
                        cleanupMedal: appStateController.cleanupMedal)
            Spacer()

            // Begin Button
            Button(action: {
                showingOceanView = true
            }, label: {
                Text("Begin")
            })
        } // VStack
        .controlSize(.large)
        .tint(.mint)
        .buttonStyle(.borderedProminent)
        .padding()
        .padding(.vertical, 32)
        .background {
            Image("homeBackground")
                .resizable()
                .scaledToFill()
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showingOceanView, onDismiss: update) {
            OceanView()
        }
        .sheet(isPresented: $showingNoteView, onDismiss: nil) {
            NoteView()
        }
        #if DEBUG
        .sheet(isPresented: $showingDevView, onDismiss: update) {
            DevView()
        }
        #endif
        .alert("medal approval alert",
               isPresented: $showingMedalApproval, actions: {})
        //        .alert("medal approval alert",
        //               isPresented: $showingMedalApproval, actions: {
        //            Button("not send", role: .cancel, action: {})
        //            Button("send", action: {})
        //        }, message: {
        //            Text("you got a new medal.")
        //        })
    }

    private func update() {
        // got a new medal?
        if let latestMedal = appStateController.cleanupMedal {
            if medal == nil || medal?.count != latestMedal.count {
                medal = appStateController.cleanupMedal
                showingMedalApproval = true
                playMedalSound()
            }
        }

        // show the AppReview in app?
        if appStateController.isShowingAppReview() {
            if let windowScene = (UIApplication.shared.connectedScenes.first
                                  as? UIWindowScene)?.windows.first?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }

    // Play the Sound Effect to approve getting a new Medal.
    private func playMedalSound() {
        if appStateController.isSoundEnable {
            medalSoundPlayer.stop()
            medalSoundPlayer.currentTime = 0.0
            medalSoundPlayer.play()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let appStateController = AppStateController()
    static var previews: some View {
        HomeView()
            .environmentObject(appStateController)
            .previewInterfaceOrientation(.portrait)
            .onAppear {
                appStateController.setCleanupCount(100)
            }
        HomeView()
            .environmentObject(appStateController)
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct ContentView: View {
    let cleanupCount: Int
    let cleanupMedal: CleanupMedal?

    var body: some View {
        HStack {
            // Cleanup Count
            Text("\(cleanupCount)")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .foregroundColor(.white)
//                .padding(.horizontal, 32)
                .shadow(radius: 20)

            // Medal
            if let medal = cleanupMedal {
                Image(medal.imageName)
                    .resizable()
                    .frame(width: 200, height: 200)
//                    .padding(.horizontal, 0)
                    .shadow(radius: 20)
            }
        } // HStack
    }
}
