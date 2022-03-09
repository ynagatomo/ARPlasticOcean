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

//    @State private var medal: CleanupMedal?

    private let roundedOrangeButtonStyle: CustomButtonStyle = .init(isEnabled: true,
                                                      cornerRadius: 10,
                                                      color: .orange,
                                                      disabledColor: .gray,
                                                      textColor: .white)

    var body: some View {
            VStack {
                // Top Bar
                HStack {
                    // Note Button
                    Button(action: {
                        showingNoteView = true
                    }, label: {
                        Image(systemName: "info.circle") // "doc.plaintext.fill")
                            .font(.largeTitle)
                            .padding(4)
                    })
                        .foregroundColor(.white)
//                    .buttonStyle(roundedOrangeButtonStyle)
                    Spacer()

                    // Dev Button
                    #if DEBUG
                    Button(action: {
                        showingDevView = true
                    }, label: {
                        Text(String("  "))
//                        Image(systemName: "gear")
                            .font(.largeTitle)
                            .padding(4)
                    })
                        .foregroundColor(.white)
  //                  .buttonStyle(roundedOrangeButtonStyle)
                    #endif

                    // Sound Button
                    Button(action: {
                        appStateController.soundEnable.toggle()
//                        appStateController.isSoundEnable.toggle()
                    }, label: {
                        if appStateController.soundEnable {
//                        if appStateController.isSoundEnable {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.largeTitle)
                                .padding(4)
                        } else {
                            Image(systemName: "speaker.slash")
                                .font(.largeTitle)
                                .padding(4)
                        }
                    })
                        .foregroundColor(.white)
//                    .buttonStyle(roundedOrangeButtonStyle)
                    //    Toggle(isOn: $appStateController.isSoundEnable) {
                    //        Image(systemName: "speaker.wave.2.fill")
                    //    }
                    // .toggleStyle(.button) // iOS 15.0+
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
                        .font(.largeTitle)
                        .padding(.horizontal, 48)
                })
                .buttonStyle(roundedOrangeButtonStyle)
            } // VStack
            .padding(.horizontal, 32)
            .padding(.vertical, 32)
        // .controlSize(.large) // iOS 15.0+
        // .tint(.mint) // iOS 15.0+
        // .buttonStyle(.borderedProminent) // iOS 15.0+
            .background(
                Image("homeBackground")
                    .resizable()
                    .scaledToFill()
            )
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
        .alert(isPresented: $showingMedalApproval) {
            Alert(title: Text("medal approval alert"),
                  message: nil,
                  dismissButton: .default(Text("ok")))
        }
        //    .alert("medal approval alert",  // iOS 15.0+
        //           isPresented: $showingMedalApproval, actions: {})
    }

    private func update() {
        // got a new medal?
        if appStateController.shouldApproveNewMedal() {
            appStateController.approvedNewMedal()
            showingMedalApproval = true
            playMedalSound()
        }

//        if let latestMedal = appStateController.cleanupMedal {
//            if medal == nil || medal?.count != latestMedal.count {
//                debugPrint("DEBUG: medal was updated.")
//                medal = appStateController.cleanupMedal
//                showingMedalApproval = true
//                playMedalSound()
//            }
//        } else {
//            medal = nil // should be reset for testing with DevView
//        }

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
        appStateController.soundManager.play(soundID: SoundManager.medalSoundID)
    }
}

struct HomeView_Previews: PreviewProvider {
    static let appStateController = AppStateController()
    static var previews: some View {
        if #available(iOS 15.0, *) {
            HomeView()
                .environmentObject(appStateController)
                .previewInterfaceOrientation(.portrait)
                .onAppear {
                    appStateController.setCleanupCount(100)
                }
            HomeView()
                .environmentObject(appStateController)
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            HomeView()
                .environmentObject(appStateController)
                .onAppear {
                    appStateController.setCleanupCount(100)
                }
        }
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
