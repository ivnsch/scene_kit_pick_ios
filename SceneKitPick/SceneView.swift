//
//  SceneView.swift
//  SceneKitPick
//
//  Created by ischuetz on 24/07/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import SceneKit
import QuartzCore

protocol ItemSelectionDelegate {
    func onItemSelected(name:String)
}

class SceneView: SCNView {
    
    var selectionDelegate:ItemSelectionDelegate!
    
    var selectedMaterial:SCNMaterial!
    
    func loadSceneAtURL(url:NSURL) {
        
        let options:Dictionary = [SCNSceneSourceCreateNormalsIfAbsentKey : true]
        
        var error:NSError?
        let maybeScene:SCNScene? = SCNScene.sceneWithURL(url, options: options, error: &error)
        
        if let scene = maybeScene? {
            self.scene = scene
            
        } else {
            println("Error loading scene: " + error!.localizedDescription)
        }
    }
    
    
    func selectNode(node:SCNNode, geometryIndex:Int) {
        
        if self.selectedMaterial {
            self.selectedMaterial.removeAllAnimations()
            self.selectedMaterial = nil
        }
        
        let unsharedMaterial:SCNMaterial = node.geometry.materials[geometryIndex].copy() as SCNMaterial
        node.geometry.replaceMaterialAtIndex(geometryIndex, withMaterial: unsharedMaterial)
        
        self.selectedMaterial = unsharedMaterial
        
        let highlightAnimation:CABasicAnimation = CABasicAnimation(keyPath: "contents")
        highlightAnimation.toValue = UIColor.blueColor()
        highlightAnimation.fromValue = UIColor.blackColor()
        
        highlightAnimation.repeatCount = MAXFLOAT
        highlightAnimation.removedOnCompletion = false
        highlightAnimation.fillMode = kCAFillModeForwards
        highlightAnimation.duration = 0.5
        highlightAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        self.selectedMaterial.emission.intensity = 1.0
        self.selectedMaterial.emission.addAnimation(highlightAnimation, forKey: "highlight")

        self.selectionDelegate.onItemSelected(node.name)
    }
    
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject()
        let location = touch.locationInView(self)
        
        let hits = self.hitTest(location, options: nil)
        
        if hits.count > 0 {
            let hit:SCNHitTestResult = hits[0] as SCNHitTestResult
            self.selectNode(hit.node, geometryIndex: hit.geometryIndex)
            
        }
    }
}
