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
    let arScene: ARScene

    init(appStateController: AppStateController) {
        self.appStateController = appStateController
        arScene = ARScene()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        debugLog("ARViewController: viewDidAppear(_:) was called.")
        let arView = ARView(frame: .zero)
        view = arView

        let anchorEntity = AnchorEntity()
        arView.scene.addAnchor(anchorEntity)

        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
    }

    //    override func viewWillDisappear(_ animated: Bool) {
    //        debugLog("ARViewController: viewWillDisappear(_:) was called.")
    //    }

    override func viewDidDisappear(_ animated: Bool) {
        debugLog("ARViewController: viewDidDisappear(_:) was called.")
        if arScene.isCleaned {
            appStateController.incrementCleanupCount() // Cleanup-count ++
        }
    }
}
