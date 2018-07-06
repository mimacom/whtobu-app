/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Instantiates styled label nodes based on a template node in a scene file.
*/

import Foundation
import ARKit

/// - Tag: TemplateLabelNode SCNNode
class Plane: SCNNode {
        
    var anchor: ARAnchor
    var label: String
    
    init(anchor: ARAnchor, label: String, box: CGRect) {
        self.anchor = anchor
        self.label = label
        
        super.init()
        
        print("Render plane with", label, box)
        
        createPlaneNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createPlaneNode() {
       
    }
    
    // MARK: Private
    
//    private func createPlaneNode() {
//        // Make the occlusion geometry slightly smaller than the plane.
//        let occlusionPlane = SCNPlane(width: CGFloat(anchor.extent.x - 0.05), height: CGFloat(anchor.extent.z - 0.05))
//        let material = SCNMaterial()
//        material.colorBufferWriteMask = []
//        material.isDoubleSided = true
//        occlusionPlane.materials = [material]
//
//        occlusionNode = SCNNode()
//        occlusionNode!.geometry = occlusionPlane
//        occlusionNode!.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
//        occlusionNode!.position = SCNVector3Make(anchor.center.x, occlusionPlaneVerticalOffset, anchor.center.z)
//
//        self.addChildNode(occlusionNode!)
//    }
//
//    private func updateOcclusionNode() {
//        guard let occlusionNode = occlusionNode, let occlusionPlane = occlusionNode.geometry as? SCNPlane else {
//            return
//        }
//        occlusionPlane.width = CGFloat(anchor.extent.x - 0.05)
//        occlusionPlane.height = CGFloat(anchor.extent.z - 0.05)
//
//        occlusionNode.position = SCNVector3Make(anchor.center.x, occlusionPlaneVerticalOffset, anchor.center.z)
//    }
//
//    override func didLoad(_ node: SKNode?) {
//        // Apply text to both labels loaded from the template.
//        guard let parent = node?.childNode(withName: "LabelNode") else {
//            fatalError("misconfigured SpriteKit template file")
//        }
//
////        SCNPlane
//
//        for case let label as SKLabelNode in parent.children {
//            label.name = text
//            label.text = text
//        }
//    }
}
