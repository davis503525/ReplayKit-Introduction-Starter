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
import ReplayKit

class GameViewController: UIViewController {
    
    var particleSystem: SCNParticleSystem!
    var buttonWindow: UIWindow!

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
        recordingButton.setTitle("Start Recording", forState: .Normal)
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
        self.buttonWindow = UIWindow(frame: self.view.frame)
        self.buttonWindow.rootViewController = HiddenStatusBarViewController()
        for button in buttons {
            self.buttonWindow.rootViewController?.view.addSubview(button)
        }
        
        self.buttonWindow.makeKeyAndVisible()
    }
    
    func startRecording(sender: UIButton) {
        if RPScreenRecorder.sharedRecorder().available {
            RPScreenRecorder.sharedRecorder().startRecordingWithMicrophoneEnabled(true, handler: { (error: NSError?) -> Void in
                if error == nil { // Recording has started
                    sender.removeTarget(self, action: "startRecording:", forControlEvents: .TouchUpInside)
                    sender.addTarget(self, action: "stopRecording:", forControlEvents: .TouchUpInside)
                    sender.setTitle("Stop Recording", forState: .Normal)
                    sender.setTitleColor(UIColor.redColor(), forState: .Normal)
                } else {
                    // Handle error
                }
            })
        } else {
            // Hide UI used for recording
        }
    }
    
    func stopRecording(sender: UIButton) {
        RPScreenRecorder.sharedRecorder().stopRecordingWithHandler { (previewController: RPPreviewViewController?, error: NSError?) -> Void in
            if previewController != nil {
                let alertController = UIAlertController(title: "Recording", message: "Do you wish to discard or view your gameplay recording?", preferredStyle: .Alert)
                
                let discardAction = UIAlertAction(title: "Discard", style: .Default) { (action: UIAlertAction) in
                    RPScreenRecorder.sharedRecorder().discardRecordingWithHandler({ () -> Void in
                        // Executed once recording has successfully been discarded
                    })
                }
                
                let viewAction = UIAlertAction(title: "View", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    self.buttonWindow.rootViewController?.presentViewController(previewController!, animated: true, completion: nil)
                })
                
                alertController.addAction(discardAction)
                alertController.addAction(viewAction)
                
                print(self.buttonWindow.rootViewController)
                self.buttonWindow.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                
                sender.removeTarget(self, action: "stopRecording:", forControlEvents: .TouchUpInside)
                sender.addTarget(self, action: "startRecording:", forControlEvents: .TouchUpInside)
                sender.setTitle("Start Recording", forState: .Normal)
                sender.setTitleColor(UIColor.blueColor(), forState: .Normal)
            } else {
                // Handle error
            }
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
