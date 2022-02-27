//
//  ARViewController.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import UIKit
import ARKit
import RealityKit

class ARViewController: UIViewController {
    var appStateController: AppStateController
    private var arScene: ARScene!

    init(appStateController: AppStateController) {
        self.appStateController = appStateController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        debugLog("ARViewController: viewDidAppear(_:) was called.")
        let arView = ARView(frame: .zero)
        #if DEBUG
        arView.debugOptions = [.showPhysics]
        #endif
        view = arView

        let anchorEntity = AnchorEntity()
        arView.scene.addAnchor(anchorEntity)

        arScene = ARScene(stageIndex: appStateController.stageIndex,
                          assetManager: appStateController.assetManager)
        arScene.prepare(arView: arView, anchor: anchorEntity)

        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)

        arScene.startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        debugLog("ARViewController: viewWillDisappear(_:) was called.")
        arScene.stopSession()
    }

    override func viewDidDisappear(_ animated: Bool) {
        debugLog("ARViewController: viewDidDisappear(_:) was called.")
        if arScene.isCleaned {
            appStateController.setCleaned() // This stage has been cleaned.
        }
    }
}
