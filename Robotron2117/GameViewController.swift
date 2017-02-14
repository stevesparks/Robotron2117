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

class GameViewController: UIViewController, GameDelegate {
    
    var currentUniverse : GameUniverse?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        newGame()
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        self.startWatchingForControllers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopWatchingForControllers()
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == .playPause {
            newGame()
        } else {
            super.pressesBegan(presses, with: event)
        }
    }
    
    func newGame() {
        let newUniverse = GameUniverse(size: UIApplication.shared.keyWindow?.bounds.size ?? CGSize(width: 1920, height: 1080))
        newUniverse.gameDelegate = self
        if let u = currentUniverse {
            newUniverse.playerOne.controller = u.playerOne.controller
            newUniverse.playerTwo.controller = u.playerTwo.controller            
        }
        if let view = self.view as! SKView? {
            view.presentScene(newUniverse, transition: SKTransition.push(with: .up, duration: 0.5))
        }
        GameUniverse.shared = newUniverse
        currentUniverse = newUniverse
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
        if note.name == .GCControllerDidConnect, let ctrl = note.object as? GCController {
            GameUniverse.shared.addController(ctrl)
        } else if note.name == .GCControllerDidDisconnect {
            if let ctrl = note.object as? GCController {
                GameUniverse.shared.removeController(ctrl)
            }
        }
    }
    
    func gameOver(_ universe: GameUniverse) {
        universe.showGameOverLabel {
            self.newGame()
        }
    }
    
}
