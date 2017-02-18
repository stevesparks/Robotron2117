//
//  GameViewController.swift
//  Nerdotron2117
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
        LeaderboardManager.shared.rootViewController = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == .menu {
            if let ctrl = ControllerManager.shared.playerOneController, ctrl.buttonAPressed {
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

    
    func gameStateDidChange(_ game: GameStateMachine) {
        
    }
    
    func gameOver(_ game: GameStateMachine) {
        
    }
}
