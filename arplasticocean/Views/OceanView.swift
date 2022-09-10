//
//  OceanView.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import SwiftUI
import ARKit
import RealityKit

struct OceanView: View {
    @Environment(\.presentationMode) var presentationMode
    // @Environment(\.dismiss) private var dismiss // iOS 15.0+

    var body: some View {
        ZStack {
            // AR View
            ARContainerView()
                .background(Color("LaunchScreenColor")) // shown during starting up the ARView

            // Buttons
            VStack {
                HStack {
                    Button(action: dismiss) { // dismiss.callAsFunction) { // iOS 15.0+
                        Image(systemName: "house")
                            .font(.largeTitle)
                            .padding(4)
                    }
                    .foregroundColor(.white)
                    // .tint(.orange) // iOS 15.0+
                    Spacer()
                }
                Spacer()
            } // VStack
            .padding(.horizontal, 32)
            .padding(.vertical, 32)
        } // ZStack
        .ignoresSafeArea()
        .onAppear {
            debugLog("OceanView: onAppear() was called.")
        }
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct OceanView_Previews: PreviewProvider {
    static let appStateController = AppStateController()
    static var previews: some View {
        OceanView()
            .environmentObject(appStateController)
    }
}

struct ARContainerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARViewController
    @EnvironmentObject var appStateController: AppStateController

//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }

    func makeUIViewController(context: Context) -> ARViewController {
        debugLog("ARContainerView: makeUIViewController(context:) was called.")
        let viewController = ARViewController(appStateController: appStateController)
        return viewController
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        debugLog("ARContainerView: updateUIViewController(context:) was called.")
    }

//    class Coordinator: NSObject {
//        var parent: ARContainerView
//        init(_ parent: ARContainerView) {
//            self.parent = parent
//        }
//    }
}
