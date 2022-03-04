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
    private var arView: ARView!
    private var arScene: ARScene!
    private var cleanedImageView: UIImageView?

    init(appStateController: AppStateController) {
        self.appStateController = appStateController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        debugLog("ARViewController: viewDidAppear(_:) was called.")
        arView = ARView(frame: .zero)
        #if DEBUG
        if devConfiguration.showingARDebugOptions {
            arView.debugOptions = [.showPhysics]
        }
        #endif
        view = arView

        setupCleanedImage()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
        view.addGestureRecognizer(tap)

        let anchorEntity = AnchorEntity()
        arView.scene.addAnchor(anchorEntity)

        arScene = ARScene(stageIndex: appStateController.stageIndex,
                          assetManager: appStateController.assetManager,
                          soundManager: appStateController.soundManager,
                          cleanedImageView: cleanedImageView)
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

    @objc func tapHandler(_ sender: UITapGestureRecognizer? = nil) {
        guard let touchInView = sender?.location(in: view) else { return }
        if let tappedEntity = arView.entity(at: touchInView) {
            arScene.tapped(tappedEntity)
        }
    }

    private func setupCleanedImage() {
        if let image: UIImage = appStateController.assetManager.cleanedImage {
            cleanedImageView = UIImageView(image: image)

            let screenWidth: CGFloat = view.frame.size.width
            let screenHeight: CGFloat = view.frame.size.height
            let minWidth = min(screenWidth, screenHeight)

            let imageWidth: CGFloat = image.size.width
            let imageHeight: CGFloat = image.size.height

            let scale: CGFloat = minWidth / imageWidth
            let scaledWidth = imageWidth * scale
            let scaledHeight = imageHeight * scale
            let rect: CGRect =
                CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)

            cleanedImageView?.frame = rect
//            imageView.center = CGPoint(x: scaledWidth / 2.0, y: scaledHeight / 2.0)
            cleanedImageView?.isHidden = true
            view.addSubview(cleanedImageView!)
        }
    }
}
