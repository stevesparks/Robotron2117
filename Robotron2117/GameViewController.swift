//
//  GameViewController.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/10/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import GameplayKit
import GameController

class GameViewController: UIViewController, GameDelegate {
    var currentGame : GameStateMachine?
    var me : GKLocalPlayer!
    
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
        
        me = {
            let x = GKLocalPlayer.localPlayer()
            x.authenticateHandler = { vc, error in
                if let vc = vc {
                    print("\(vc)")
                    self.present(vc, animated: true)
                } else if let error = error {
                    print("\(error)")
                }
            }
            print("Me: \(x.debugDescription)")
            return x
        }()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(GKPlayerAuthenticationDidChangeNotificationName), object: nil, queue: OperationQueue.main, using: { _ in
            print("Updated! \(self.me.debugDescription)")
            print("\(LeaderboardManager.shared)")
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopWatchingForControllers()
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == .menu {
            if let ctrl = currentGame?.playerOneController, ctrl.buttonAPressed {
                return
            }
            super.pressesBegan(presses, with: event)
            return
        }
        if let game = currentGame {
            game.pressesBegan(presses, with: event)
            return
        }
        super.pressesBegan(presses, with: event)
    }
    
    func newGame() {
        if let view = self.view as? SKView {
            currentGame = GameStateMachine(view, gameDelegate: self)
            currentGame?.begin()
        } else {
            print("No")
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
        if note.name == .GCControllerDidConnect, let ctrl = note.object as? GCController {
            currentGame?.addController(ctrl)
        } else if note.name == .GCControllerDidDisconnect {
            if let ctrl = note.object as? GCController {
                currentGame?.removeController(ctrl)
            }
        }
    }
    
    func gameStateDidChange(_ game: GameStateMachine) {
        
    }
    
    func gameOver(_ game: GameStateMachine) {
        
    }
}
