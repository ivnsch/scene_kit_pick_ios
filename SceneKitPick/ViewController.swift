//
//  ViewController.swift
//  SceneKitPick
//
//  Created by ischuetz on 24/07/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ItemSelectionDelegate {
    
    @IBOutlet var sceneView: SceneView!
    @IBOutlet var selectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView.allowsCameraControl = true
        self.sceneView.jitteringEnabled = true
        self.sceneView.backgroundColor = UIColor.blackColor()
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("body", withExtension: "dae")
        self.sceneView.loadSceneAtURL(url)
        
        self.sceneView.selectionDelegate = self

    }

    //Map the object names from .dae to strings we want to show to the user
    let partNames = ["head" : "Head",
        "eye_l" : "Left eye",
        "eye_r" : "Right eye",
        "neck" : "Neck",
        "torso" : "Torso",
        "arm_l" : "Left arm",
        "arm_r" : "Right arm",
        "hand_l" : "Left hand",
        "hand_r" : "Right hand",
        "leg_l" : "Left leg",
        "leg_r" : "Right leg",
        "foot_l" : "Left foot",
        "foot_r" : "Right foot"]
    
    
    func onItemSelected(name: String) {
        println("name: " + name)
        let partName = partNames[name]
        self.selectionLabel.text = "You selected: " + partName!
    }

}

