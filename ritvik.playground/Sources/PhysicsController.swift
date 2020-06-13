import UIKit
import PlaygroundSupport
import ARKit
import Foundation

public class PhysicsController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    var ball = SCNNode()
    var box = SCNNode()
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "MainScene.scn")!
        
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        
        
        //:I was going to add a delay between when the user loads into the view and when the ball and platform show up but later I decided not to due to complication errors.
        
        
        // Set the scene to the view
        sceneView.scene = scene
        //let wait:SCNAction = SCNAction.wait(duration: 2)
        //  let runAfter:SCNAction = SCNAction.run { _ in
        self.addSceneContent()
        //    }
        
        //  let seq:SCNAction = SCNAction.sequence([wait, runAfter])
        
        // sceneView.scene.rootNode.runAction(seq)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.view = sceneView
        
    }
    @objc func handleTap(sender: UITapGestureRecognizer)
    {
        //  guard let sceneView = sender.view as? ARSCNView else {return }
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        if !hitTestResult.isEmpty {
            for hitResult in hitTestResult {
                // Debugging feature - print(hitTestResult.node.name)
                if (hitResult.node == ball)
                {
                    ball.physicsBody?.applyForce(SCNVector3(0,10,0), asImpulse: true)
                }
            }
        }
    }
    
    func addSceneContent() {
        
        let dummyNode = self.sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        dummyNode?.position = SCNVector3(0,-5,-10)
        // Can refer to whatever node the program is referring to
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
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
        self.sceneView.scene.rootNode.addChildNode(lightNode)
        
        
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
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors wif consistent tracking is required
        
    }
}
