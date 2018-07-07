//
//  ViewController.swift
//  RETY
//
//  Created by Sergej Kunz on 06.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision
import Foundation

class ViewController: UIViewController, UIGestureRecognizerDelegate, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!

    private lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!

        // Set the scene to the view
        sceneView.scene = scene
        sceneView.session.delegate = self

        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false

        sceneView.debugOptions = [
            ARSCNDebugOptions.showFeaturePoints,
//            ARSCNDebugOptions.showWorldOrigin
        ]

        // Hook up status view controller callback.
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartSession()
        }
    }

    func getMesh() -> SCNNode {
        let halfSide: Float = 1.0

        let positions = [
            SCNVector3Make(-halfSide, -halfSide, halfSide),
            SCNVector3Make(halfSide, -halfSide, halfSide),
            SCNVector3Make(-halfSide, -halfSide, -halfSide),
            SCNVector3Make(halfSide, -halfSide, -halfSide),
            SCNVector3Make(-halfSide, halfSide, halfSide),
            SCNVector3Make(halfSide, halfSide, halfSide),
            SCNVector3Make(-halfSide, halfSide, -halfSide),
            SCNVector3Make(halfSide, halfSide, -halfSide)
        ]

        let indices = [
            // bottom
            0, 2, 1,
            1, 2, 3,
            // back
            2, 6, 3,
            3, 6, 7,
            // left
            0, 4, 2,
            2, 4, 6,
            // right
            1, 3, 5,
            3, 7, 5,
            // front
            0, 1, 4,
            1, 5, 4,
            // top
            4, 5, 6,
            5, 7, 6
        ]

        let vertexSource = SCNGeometrySource(vertices: positions)
        let indexData = NSData(bytes: indices, length: indices.capacity)

        let element = SCNGeometryElement(data: indexData as Data, primitiveType: .triangles, primitiveCount: indices.count, bytesPerIndex: Int.bitWidth)

        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])

        let node = SCNNode(geometry: geometry)

//        sceneView.scene.rootNode.addChildNode(node)
//        return node

        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        cubeNode.position = SCNVector3(0, 0, -0.2)

        return cubeNode
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // Pass camera frames received from ARKit to Vision (when not already processing one)
    /// - Tag: ConsumeARFrames
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do not enqueue other buffers for processing while another Vision task is still running.
        // The camera stream has only a finite amount of buffers available; holding too many buffers for analysis would starve the camera.
        guard currentBuffer == nil, case .normal = frame.camera.trackingState else {
            return
        }

        // Retain the image buffer for Vision processing.
        self.currentBuffer = frame.capturedImage
        classifyCurrentImage()
    }

    // MARK: - Vision classification

    // Vision classification request and model
    /// - Tag: ClassificationRequest
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            // Instantiate the model from its generated Swift class.

            let mlmodel = ObjectDetector()
            let userDefined: [String: String] = mlmodel.model.modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey]! as! [String: String]
            let labels = userDefined["classes"]!.components(separatedBy: ",")

            nmsThreshold = Float(userDefined["non_maximum_suppression_threshold"]!) ?? 0.5

            let model = try VNCoreMLModel(for: mlmodel.model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })

            request.imageCropAndScaleOption = .scaleFill

            // Use CPU for Vision processing to ensure that there are adequate GPU resources for rendering.
            //request.usesCPUOnly = true

            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()

    struct Prediction {
        let label: String
        let confidence: Float
        let boundingBox: CGRect
    }

    // The pixel buffer being held for analysis; used to serialize Vision requests.
    private var currentBuffer: CVPixelBuffer?

    // Queue for dispatching vision classification requests
    private let visionQueue = DispatchQueue(label: "com.example.apple-samplecode.ARKitVision.serialVisionQueue")

    // Run the Vision+ML classifier on the current image buffer.
    /// - Tag: ClassifyCurrentImage
    private func classifyCurrentImage() {
        // Most computer vision tasks are not rotation agnostic so it is important to pass in the orientation of the image with respect to device.
        let orientation = CGImagePropertyOrientation(UIDevice.current.orientation)

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: currentBuffer!, orientation: orientation)
        visionQueue.async {
            do {
                // Release the pixel buffer when done, allowing the next buffer to be processed.
                defer {
                    self.currentBuffer = nil
                }
                try requestHandler.perform([self.classificationRequest])
            } catch {
                print("Error: Vision request failed with error \"\(error)\"")
            }
        }
    }

    // Classification results
    private var identifierString = ""
    private var confidence: VNConfidence = 0.0

    // Handle completion of the Vision request and choose results to display.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            return
        }

        var unorderedPredictions = [Prediction]()

        for case let foundObject as VNRecognizedObjectObservation in results {
            let bestLabel = foundObject.labels.first! // Label with highest confidence
            let objectBounds = foundObject.boundingBox // [x, y, width, height]

            // Use the computed values.
            print(bestLabel.identifier, bestLabel.confidence, objectBounds)

            identifierString = bestLabel.identifier
            confidence = bestLabel.confidence

            unorderedPredictions.append(Prediction(
                    label: bestLabel.identifier,
                    confidence: bestLabel.confidence,
                    boundingBox: foundObject.boundingBox
            ))

//            placeBoxAtLocation(box: objectBounds, label: identifierString)
//
//            DispatchQueue.main.async { [weak self] in
//                self?.displayClassifierResults()
//            }
        }

        var predictions: [Prediction] = []
        let orderedPredictions = unorderedPredictions.sorted { $0.confidence > $1.confidence }
        var keep = [Bool](repeating: true, count: orderedPredictions.count)
        for i in 0..<orderedPredictions.count {
            if keep[i] {
                predictions.append(orderedPredictions[i])
                let bbox1 = orderedPredictions[i].boundingBox
                for j in (i+1)..<orderedPredictions.count {
                    if keep[j] {
                        let bbox2 = orderedPredictions[j].boundingBox
                        if IoU(bbox1, bbox2) > nmsThreshold {
                            keep[j] = false
                        }
                    }
                }
            }
        }

        for case let prediction in predictions {
            DispatchQueue.main.async { [weak self] in
                self?.placeBoxAtLocation(box: prediction.boundingBox, label: prediction.label + " " + String(prediction.confidence * 100) + "%")
                self?.displayClassifierResults()
            }
        }
    }

    public func IoU(_ a: CGRect, _ b: CGRect) -> Float {
        let intersection = a.intersection(b)
        let union = a.union(b)
        return Float((intersection.width * intersection.height) / (union.width * union.height))
    }

    // Show the classification results in the UI.
    private func displayClassifierResults() {
        guard !self.identifierString.isEmpty else {
            return // No object was classified.
        }
        let message = String(format: "Detected \(self.identifierString) with %.2f", self.confidence * 100) + "% confidence"
        statusViewController.showMessage(message)
    }

    // MARK: - Tap gesture handler & ARSKViewDelegate

    // Labels for classified objects by ARAnchor UUID
    private var anchorLabels = [UUID: InfoPlane]()
    private var nmsThreshold: Float = 0.0

    // When the user taps, add an anchor associated with the current classification result.
    /// - Tag: PlaceLabelAtLocation
    @IBAction func placeLabelAtLocation(sender: UITapGestureRecognizer) {
//        let hitLocationInView = sender.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(hitLocationInView, types: [.featurePoint, .estimatedHorizontalPlane])
//        if let result = hitTestResults.first {
//
//            // Add a new anchor at the tap location.
//            let anchor = ARAnchor(transform: result.worldTransform)
//            sceneView.session.add(anchor: anchor)
//
//            // Track anchor ID to associate text with the anchor after ARKit creates a corresponding SKNode.
//            anchorLabels[anchor.identifier] = identifierString
//        }
    }

    private func placeBoxAtLocation(box: CGRect, label: String) {

        let hitTestResults = sceneView.hitTest(box.origin, types: [.featurePoint])

//        print("Hit Test Results", hitTestResults)

        if let result = hitTestResults.first {
    
            for existingAnchor in sceneView.session.currentFrame!.anchors {
                sceneView.session.remove(anchor: existingAnchor)
            }
            
            anchorLabels = [UUID: InfoPlane]()
            
            // Add a new anchor at the location.
            let anchor = ARAnchor(transform: result.worldTransform)
            sceneView.session.add(anchor: anchor)

            // Track anchor ID to associate text with the anchor after ARKit creates a corresponding SKNode.
            anchorLabels[anchor.identifier] = InfoPlane(label: label, box: box)

//            print("Added box", label, anchor)
        }
    }

    struct InfoPlane {
        let label: String
        let box: CGRect
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard let infoPlane = anchorLabels[anchor.identifier] else {
            print("missing expected associated label for anchor")
            return
        }

//        let label = Plane(anchor: anchor, label: infoPlane.label, box: infoPlane.box)
//        print("Add label", label)

//        node.addChildNode(getMesh())

        let plane = SCNPlane(width: 0.02, height: 0.02)
        
        let material = SCNMaterial()
        let color: UIColor
        
        if (infoPlane.label.contains("bike")) {
            color = UIColor.green
        } else if (infoPlane.label.contains("person")) {
            color = UIColor.blue
        } else {
            color = UIColor.red
        }
        
        material.diffuse.contents = color
        material.specular.contents = UIColor.white
        material.shininess = 1
        material.isDoubleSided = true
        material.transparency = 0.3
        plane.materials = [material]

        let text = SCNText(string: infoPlane.label.capitalized, extrusionDepth: 0.02)
        let font = UIFont(name: "Futura", size: 0.30)
        text.font = font
        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        text.firstMaterial?.diffuse.contents = UIColor.yellow
        text.firstMaterial?.specular.contents = UIColor.white
        text.firstMaterial?.isDoubleSided = true
        text.chamferRadius = 0.01

        let (minBound, maxBound) = text.boundingBox

        let textNode = SCNNode(geometry: text)
        textNode.pivot = SCNMatrix4MakeTranslation((maxBound.x - minBound.x) / 2, minBound.y, 0.02 / 2)
        textNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        textNode.position = SCNVector3Make(0, 0, 0)

        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(0, 0, 0)
        planeNode.addChildNode(textNode)

        node.addChildNode(planeNode)
    }

    // MARK: - AR Session Handling

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        statusViewController.showTrackingQualityInfo(for: camera.trackingState, autoHide: true)

        switch camera.trackingState {
        case .notAvailable, .limited:
            statusViewController.escalateFeedback(for: camera.trackingState, inSeconds: 3.0)
        case .normal:
            statusViewController.cancelScheduledMessage(for: .trackingStateEscalation)
                // Unhide content after successful relocalization.
//            setOverlaysHidden(false)
        }
    }

    internal func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else {
            return
        }

        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]

        // Filter out optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }

//    private func sessionWasInterrupted(_ session: ARSession) {
//        setOverlaysHidden(true)
//    }

    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        /*
         Allow the session to attempt to resume after an interruption.
         This process may not succeed, so the app must be prepared
         to reset the session if the relocalizing status continues
         for a long time -- see `escalateFeedback` in `StatusViewController`.
         */
        return true
    }

//    private func setOverlaysHidden(_ shouldHide: Bool) {
//        sceneView.scene.children.forEach { node in
//            if shouldHide {
//                // Hide overlay content immediately during relocalization.
//                node.alpha = 0
//            } else {
//                // Fade overlay content in after relocalization succeeds.
//                node.run(.fadeIn(withDuration: 0.5))
//            }
//        }
//    }

    private func restartSession() {
        statusViewController.cancelAllScheduledMessages()
        statusViewController.showMessage("RESTARTING SESSION")

        anchorLabels = [UUID: InfoPlane]()

        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    // MARK: - Error handling

    private func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.restartSession()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
}
