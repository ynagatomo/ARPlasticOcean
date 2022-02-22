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
    @Environment(\.dismiss) private var dismiss
    //    @EnvironmentObject var stateController: StateController

    var body: some View {
        ZStack {
            // AR View
            ARContainerView()

            // Buttons
            VStack {
                HStack {
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "house")
                            .font(.title)
                            .padding(22)
                    }
                    .tint(.orange)
                    Spacer()
                }
                Spacer()
            } // VStack
            .padding(.vertical, 44)
        } // ZStack
        .ignoresSafeArea()
        .onAppear {
            debugLog("OceanView: onAppear() was called.")
        }
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

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> ARViewController {
        debugLog("ARContainerView: makeUIViewController(context:) was called.")
        let viewController = ARViewController(appStateController: appStateController)
        return viewController
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        debugLog("ARContainerView: updateUIViewController(context:) was called.")
    }

    class Coordinator: NSObject {
        var parent: ARContainerView
        init(_ parent: ARContainerView) {
            self.parent = parent
        }
    }
}
