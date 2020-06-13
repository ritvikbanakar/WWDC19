//
//  Extensions.swift
//  Portal3
//
//  Created by Ritvik Banakar on 3/24/19.
//  Copyright © 2019 Ritvik Banakar. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

var width: CGFloat = 0.02
var height: CGFloat = 1
var length : CGFloat = 1

var doorLength : CGFloat = 0.3

func createBox(isDoor: Bool) -> SCNNode {
    let node = SCNNode()
    
    // Add the door you walk into
    let firstBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
    let firstBoxNode = SCNNode(geometry: firstBox)
    firstBoxNode.renderingOrder = 200
    
    node.addChildNode(firstBoxNode)
    
    
    // Add outer box that is what the user goes to
    let maskedBox = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
    maskedBox.firstMaterial?.diffuse.contents = UIColor.green
    maskedBox.firstMaterial?.transparency = 0.00001
    
    let maskedBoxNode = SCNNode(geometry: maskedBox)
    
    // MUST BE LESS THAN FIRST BOX
    maskedBoxNode.renderingOrder = 100
    maskedBoxNode.position = SCNVector3.init(width, 0,0)
    
    node.addChildNode(maskedBoxNode)
    
    return node
}

extension FloatingPoint {
    var degreesToRadians: Self {
        return self * .pi/180
    }
    var randiansToDegrees: Self {
        return self * 180/(.pi)
    }
}
