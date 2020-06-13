//: Playground - noun: a place where people can play

import UIKit
import SceneKit
import PlaygroundSupport

// Set up the scene view
let frame = CGRect(
    x: 0,
    y: 0,
    width: 500,
    height: 300)
let scene = SCNScene(named: "MainScene.scn")

 
 scene.showsStatistics = true
 scene.autoenablesDefaultLighting = true
 scene.allowsCameraControl = true
 scene.scene = SCNScene()
 
 scene.rootNode.enumerateChildNodes { (node, _) in
 if (node.name == "ball")
 {
 ball = node
 ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options: nil))
 ball.physicsBody?.isAffectedByGravity = true
 ball.physicsBody?.restitution = 1
 
 } else if(node.name == "box")
 {
 box = node
 let boxGeometry = box.geometry
 let boxShape:SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometry!, options: nil)
 box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
 box.physicsBody?.restitution = 1
 }
 }
 let light = SCNLight()
 light.type = SCNLight.LightType.omni
 let lightNode = SCNNode()
 lightNode.light = light
 lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
 sceneView.scene!.rootNode.addChildNode(lightNode)

PlaygroundSupport.PlaygroundPage.current.liveView = scene as? PlaygroundLiveViewable

