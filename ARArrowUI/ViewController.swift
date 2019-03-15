//
//  ViewController.swift
//  ARArrowUI
//
//  Created by Toshihiro Goto on 2019/03/14.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var DirectionFeild: UITextField!
    
    @IBOutlet var sceneView: ARSCNView!
    
    
    private var target:SCNNode!
    
    private var overlayScene: SKScene!
    
    private var arrowL: SKSpriteNode!
    private var arrowR: SKSpriteNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "main.scn")!
        
        target = scene.rootNode.childNode(withName: "sphere", recursively: true)!
        
        // Overlay
        overlayScene = SKScene()
        overlayScene.size = UIScreen.main.bounds.size
        overlayScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        arrowL = SKSpriteNode(imageNamed: "arrow_l.png")
        arrowL.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        arrowL.position = CGPoint(x: -overlayScene.size.width / 2, y: 0.0)
        arrowL.alpha = 0.0
        overlayScene.addChild(arrowL)
        
        arrowR = SKSpriteNode(imageNamed: "arrow_r.png")
        arrowR.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        arrowR.position = CGPoint(x: overlayScene.size.width / 2, y: 0.0)
        arrowR.alpha = 0.0
        overlayScene.addChild(arrowR)
        
        sceneView.overlaySKScene = overlayScene
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        overlayScene.size = size
        
        arrowL.position = CGPoint(x: -overlayScene.size.width / 2, y: 0.0)
        arrowR.position = CGPoint(x: overlayScene.size.width / 2, y: 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.environmentTexturing = .automatic
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        let cameraNode:SCNNode! = sceneView.pointOfView
        
        let transform = cameraNode.simdConvertTransform(target.simdTransform, from: nil)
        
        ///print(param[3])
        
        if !sceneView.isNode(target, insideFrustumOf: cameraNode) {
            if transform[3][0] > 0 {
                arrowL.alpha = 0
                arrowR.alpha = 1
            }else{
                arrowL.alpha = 1
                arrowR.alpha = 0
            }
        }else{
            arrowL.alpha = 0
            arrowR.alpha = 0
        }
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
