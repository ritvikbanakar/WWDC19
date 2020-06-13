import UIKit
import PlaygroundSupport
import ARKit
import Foundation

//
//  ViewController.swift
//  Portal3
//
//  Created by Ritvik Banakar on 3/24/19
//  Copyright © 2019 Ritvik Banakar. All rights reserved.

public class LitController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    var width : CGFloat = 0.03
    var height : CGFloat = 1
    var length : CGFloat = 1
    
    var doorLength : CGFloat = 0.3
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView(frame: CGRect(x: 0.0, y: 0.0, width: 500.0, height: 600.0))
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        setupScene()
        self.view = sceneView
        
    }
    
    override public func viewWillAppear(_ aboutd: Bool) {
        super.viewWillAppear(aboutd)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override public func viewWillDisappear(_ aboutd: Bool) {
        super.viewWillDisappear(aboutd)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func createBox(isDoor : Bool) -> SCNNode {
        let node = SCNNode()
        
        //Add First Box
        let firstBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
        firstBox.firstMaterial?.diffuse.contents = UIColor.green
        let firstBoxNode = SCNNode(geometry: firstBox)
        firstBoxNode.renderingOrder = 200
        
        node.addChildNode(firstBoxNode)
        
        //Add Masked Box
        let maskedBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
        maskedBox.firstMaterial?.diffuse.contents = UIColor.green
        maskedBox.firstMaterial?.transparency = 0.000000001
        
        let maskedBoxNode = SCNNode(geometry: maskedBox)
        maskedBoxNode.renderingOrder = 100
        maskedBoxNode.position = SCNVector3.init(width, 0, 0)
        
        node.addChildNode(maskedBoxNode)
        
        return node
    }
   
    func setupScene() {
        
        
        let node = SCNNode()
        node.position = SCNVector3.init(0, 0, -1.7)
        
        
        
        let basketScene = SCNScene(named: "basket.scn")!
        let basket = basketScene.rootNode.childNode(withName: "Basket", recursively: true)!
        basket.position = SCNVector3.init(0, 0, (-length / 2) + width + 0.2)
        basket.renderingOrder = 50

        node.addChildNode(basket)
        
        let leftWall = createBox(isDoor: false)
        leftWall.position = SCNVector3.init((-length / 2) + width, 0, 0)
        leftWall.eulerAngles = SCNVector3.init(0, 180.0.degreesToRadians, 0)
        
        let rightWall = createBox(isDoor: false)
        rightWall.position = SCNVector3.init((length / 2) - width, 0, 0)
        
        let topWall = createBox(isDoor: false)
        topWall.position = SCNVector3.init(0, (height / 2) - width, 0)
        topWall.eulerAngles = SCNVector3.init(0, 0, 90.0.degreesToRadians)
        
       let bottomWall = createBox(isDoor: false)
        bottomWall.position = SCNVector3.init(0, (-height / 2) + width, 0)
        bottomWall.eulerAngles = SCNVector3.init(0, 0, -90.0.degreesToRadians)
        
        let backWall = createBox(isDoor: false)
        backWall.position = SCNVector3.init(0, 0, (-length / 2) + width)
        backWall.eulerAngles = SCNVector3.init(0, 90.0.degreesToRadians, 0)
        
        let leftDoorSide = createBox(isDoor: true)
        leftDoorSide.position = SCNVector3.init((-length / 2 + width) + (doorLength / 2), 0, (length / 2) - width)
        leftDoorSide.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        let rightDoorSide = createBox(isDoor: true)
        rightDoorSide.position = SCNVector3.init((length / 2 - width) - (doorLength / 2), 0, (length / 2) - width)
        rightDoorSide.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        //Create Light
        
        let light = SCNLight()
        light.type = .spot
        light.spotInnerAngle = 70
        light.spotOuterAngle = 120
        light.zNear = 0.00001
        light.zFar = 5
        light.castsShadow = true
        light.shadowRadius = 200
        light.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        light.shadowMode = .deferred
        let constraint = SCNLookAtConstraint(target: bottomWall)
        constraint.isGimbalLockEnabled = true
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3.init(0, 0.4, 0)
        lightNode.constraints = [constraint]
        node.addChildNode(lightNode)
        
        //Adding Nodes to Main Node
        node.addChildNode(leftWall)
        node.addChildNode(rightWall)
        node.addChildNode(topWall)
        node.addChildNode(bottomWall)
        node.addChildNode(backWall)
        node.addChildNode(leftDoorSide)
        node.addChildNode(rightDoorSide)
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    
    
    
    
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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




extension FloatingPoint {
    var degreesToRadians : Self {
        return self * .pi / 180
    }
    var radiansToDegrees : Self {
        return self * 180 / .pi
    }
}




