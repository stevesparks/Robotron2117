//
//  GameViewController.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/10/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameController

class GameViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startWatchingForControllers()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        let sceneNode = GameUniverse.shared
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
    func startWatchingForControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.notify), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.notify), name: .GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery(completionHandler: {})
    }
    
    func stopWatchingForControllers() {
        GCController.stopWirelessControllerDiscovery()
    }
    
    func notify(note: Notification) {
        if note.name == .GCControllerDidConnect {
            if let ctrl = note.object as? GCController,
                let gamepad = ctrl.microGamepad,
                ctrl.extendedGamepad == nil {
                GameUniverse.shared.playerOne.controller = RemoteControl(gamepad)
            }
        } else if note.name == .GCControllerDidDisconnect {
            if let ctrl = note.object as? GCController,
                let _ = ctrl.microGamepad {
                GameUniverse.shared.playerOne.controller = nil
            }
        }
    }
    
}
