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
    private var anchorEntity: AnchorEntity!
    private var movingCamera: MovingCamera?

    init(appStateController: AppStateController) {
        self.appStateController = appStateController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        debugLog("ARViewController: viewDidAppear(_:) was called.")
        #if targetEnvironment(simulator)
        arView = ARView(frame: .zero)
        #else
        // automatically configure session : disable
        if ProcessInfo.processInfo.isiOSAppOnMac {
            debugLog("DEBUG: Process Info: iOS app on macOS")
            arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: true)
        } else {
            debugLog("DEBUG: Process Info: not on macOS")
            arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        }
        #endif
        arView.session.delegate = self

        #if DEBUG
        if devConfiguration.showingARDebugOptions {
            arView.debugOptions = [.showPhysics]
        }
        #endif
        view = arView
        // view.backgroundColor = UIColor(named: "LaunchScreenColor")

        setupCleanedImage()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
        view.addGestureRecognizer(tap)

        anchorEntity = AnchorEntity()
        arView.scene.addAnchor(anchorEntity)

        #if DEBUG
        if devConfiguration.usingMovingCamera {
            let cameraEntity = addPerspectiveCamera()
            movingCamera = MovingCamera(camera: cameraEntity)
        }
        #endif

        arScene = ARScene(stageIndex: appStateController.stageIndex,
                          assetManager: appStateController.assetManager,
                          soundManager: appStateController.soundManager,
                          cleanedImageView: cleanedImageView)
        arScene.prepare(arView: arView, anchor: anchorEntity,
                          camera: movingCamera)

        #if !targetEnvironment(simulator)
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            let config = ARWorldTrackingConfiguration()
            arView.session.run(config)
        }
        #endif

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
            cleanedImageView?.isHidden = true
            view.addSubview(cleanedImageView!)
        }
    }
}

#if DEBUG
extension ARViewController {
    private func addPerspectiveCamera() -> PerspectiveCamera {
        let camera = PerspectiveCamera()    // : Entity
        camera.name = "moving_camera"
        anchorEntity.addChild(camera)
        return camera
    }
}
#endif

/// The extension for ARSessionDelegate
///
/// Be careful of the thread because these will be called in the background thread
extension ARViewController: ARSessionDelegate {
    // Monitor the delegation call during development. No function to do in release mode.
    #if DEBUG
    /// tells that ARAnchors was added cause of like a plane-detection
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        // <AREnvironmentProbeAnchor> can be added for environmentTexturing
        debugLog("DEBUG: AR-DELEGATE: didAdd anchors: [ARAnchor] : \(anchors)")
        assertionFailure("The session(_:didAdd) should not be called.")
    }

    /// tells that ARAnchors were changed cause of like a progress of plane-detection
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // <AREnvironmentProbeAnchor> can be added for environmentTexturing
        debugLog("DEBUG: AR-DELEGATE: ARSessionDelegate: session(_:didUpdate) was called. \(anchors) were updated.")
        assertionFailure("The session(_:didUpdate) should not be called.")
    }

    /// tells that the ARAnchors were removed
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        debugLog("DEBUG: AR-DELEGATE: The session(_:didRemove) was called.  [ARAnchor] were removed.")
        assertionFailure("The session(_:didUpdate) should not be called.")
    }

    /// tells that the AR session was interrupted due to app switching or something
    func sessionWasInterrupted(_ session: ARSession) {
        debugLog("DEBUG: AR-DELEGATE: The sessionWasInterrupted(_:) was called.")
        // There is no special response to this at this moment. System will handle all.
            // DispatchQueue.main.async {
            //   - do something if necessary
            // }
    }

    /// tells that the interruption was ended
    func sessionInterruptionEnded(_ session: ARSession) {
        debugLog("DEBUG: AR-DELEGATE: The sessionInterruptionEnded(_:) was called.")
        // There is no special response to this at this moment.
            // DispatchQueue.main.async {
            //   - reset the AR tracking
            //   - do something if necessary
            // }
    }

    /// tells that the ARFrame was updated
    //    func session(_ session: ARSession, didUpdate frame: ARFrame) {
    //    }

    /// tells that the camera's tracking state was changed
    ///
    /// enum ARCamera.TrackingState
    ///     case  notAvailable
    ///     case  limited(ARCamera.TrackingState.Reason)
    ///     case  normal
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        debugLog("DEBUG: AR-DELEGATE: changed to ARCamera.TrackingState = \(camera.trackingState)")
        // No special response to this at this moment.
    }
    #endif

    /// tells that an error was occurred
    ///
    /// - When the users don't allow to access the camera, this delegate will be called.
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    func session(_ session: ARSession, didFailWithError error: Error) {
        debugLog("DEBUG: AR-DELEGATE: The didFailWithError was called. error = \(error.localizedDescription)")
        guard let arerror = error as? ARError else { return }

        // dump the errorCase
        #if DEBUG
        let errorCase: String
        switch arerror.errorCode {
        case ARError.Code.requestFailed.rawValue: errorCase = "requestFailed"
        case ARError.Code.cameraUnauthorized.rawValue: errorCase = "cameraUnauthorized"
        case ARError.Code.fileIOFailed.rawValue: errorCase = "fileIOFailed"
        case ARError.Code.insufficientFeatures.rawValue: errorCase = "insufficientFeatures"
        case ARError.Code.invalidConfiguration.rawValue: errorCase = "invalidConfiguration"
        case ARError.Code.invalidReferenceImage.rawValue: errorCase = "invalidReferenceImage"
        case ARError.Code.invalidReferenceObject.rawValue: errorCase = "invalidReferenceObject"
        case ARError.Code.invalidWorldMap.rawValue: errorCase = "invalidWorldMap"
        case ARError.Code.microphoneUnauthorized.rawValue: errorCase = "microphoneUnauthorized"
        case ARError.Code.objectMergeFailed.rawValue: errorCase = "objectMergeFailed"
        case ARError.Code.sensorFailed.rawValue: errorCase = "sensorFailed"
        case ARError.Code.sensorUnavailable.rawValue: errorCase = "sensorUnavailable"
        case ARError.Code.unsupportedConfiguration.rawValue: errorCase = "unsupportedConfiguration"
        case ARError.Code.worldTrackingFailed.rawValue: errorCase = "worldTrackingFailed"
        case ARError.Code.geoTrackingFailed.rawValue: errorCase = "geoTrackingFailed"
        case ARError.Code.geoTrackingNotAvailableAtLocation.rawValue: errorCase = "geoTrackingNotAvailableAtLocation"
        case ARError.Code.locationUnauthorized.rawValue: errorCase = "locationUnauthorized"
        case ARError.Code.invalidCollaborationData.rawValue: errorCase = "invalidCollaborationData"
        default: errorCase = "unknown"
        }
        debugLog("DEBUG: AR-DELEGATE:    errorCase = \(errorCase)")
        #endif

        // dump the errorWithInfo
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        // remove optional error messages and connect into one string
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        debugLog("DEBUG: AR-DELEGATE: errorWithInfo: \(errorMessage)")

        // handle issues
        if arerror.errorCode == ARError.Code.cameraUnauthorized.rawValue {
            // Error: The camera access is not allowed.
            debugLog("DEBUG: AR-DELEGATE: Camera access is unauthorized.")
            // show an alert
            DispatchQueue.main.async {
                let alertController =
                    UIAlertController(title: NSLocalizedString("ar_camera_notallowed_alert_title",
                                                               comment: "Alert Title: Camera access is not allowed."),
                                      message: NSLocalizedString("ar_camera_notallowd_alert_message",
                                                               comment: "Alert Message: Camera access is not allowed."),
                                      preferredStyle: .alert)
                // Just close the alert. When the setting with Setting app is changed,
                // the app will be restarted by the system.
                let restartAction = UIAlertAction(title: NSLocalizedString("ar_camera_notallowd_alert_ok",
                                                               comment: "Alert Button: Camera access is not allowed."),
                                                               style: .default) { _ in
                    alertController.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(restartAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else if arerror.errorCode == ARError.Code.unsupportedConfiguration.rawValue {
            // Error: Unsupported Configuration
            // The app is running on macOS(w/M1) or Simulator.
            debugLog("DEBUG: AR-DELEGATE: error: unsupportedConfiguration. (running on macOS or Simulator)")
            // Nothing to do.
        } else {
            // Error: Something else
            // Nothing to do.
        }
    }
}
