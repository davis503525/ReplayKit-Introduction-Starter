//
//  GameViewController.swift
//  ReplayKit Introduction
//
//  Created by Davis Allie on 6/12/2015.
//  Copyright (c) 2015 tutsplus. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var particleSystem: SCNParticleSystem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        self.particleSystem = SCNParticleSystem(named: "Fire", inDirectory: nil)!
        self.particleSystem.birthRate = 0
        let node = SCNNode()
        node.addParticleSystem(self.particleSystem)
        scene.rootNode.addChildNode(node)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        let recordingButton = UIButton(type: .System)
        recordingButton.setTitle("Start recording", forState: .Normal)
        recordingButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        recordingButton.addTarget(self, action: "startRecording:", forControlEvents: .TouchUpInside)
        
        let fireButton = UIButton(type: .Custom)
        fireButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        fireButton.backgroundColor = UIColor.greenColor()
        fireButton.clipsToBounds = true
        fireButton.layer.cornerRadius = 35.0
        fireButton.addTarget(self, action: "fireButtonTouchedDown:", forControlEvents: .TouchDown)
        fireButton.addTarget(self, action: "fireButtonTouchedUp:", forControlEvents: .TouchUpInside)
        fireButton.addTarget(self, action: "fireButtonTouchedUp:", forControlEvents: .TouchUpOutside)
        fireButton.frame.origin.y = self.view.frame.height - 78
        fireButton.center.x = self.view.center.x
        
        self.addButtons([recordingButton, fireButton])
    }
    
    func addButtons(buttons: [UIButton]) {
        for button in buttons {
            self.view.addSubview(button)
        }
    }
    
    func fireButtonTouchedDown(sender: UIButton) {
        self.particleSystem.birthRate = 455
    }
    
    func fireButtonTouchedUp(sender: UIButton) {
        self.particleSystem.birthRate = 0
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
