//
//  GameStateMachine.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/15/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import GameplayKit


protocol GameDelegate : NSObjectProtocol {
    func gameStateDidChange(_ game: GameStateMachine)
    func gameOver(_ game: GameStateMachine)
}

class GameStateMachine : GKStateMachine, GameLevelDelegate, AttractScreenDelegate {
    weak var scenekitView : SKView?
    weak var gameDelegate : GameDelegate?
    
    
    var attractScreen : AttractScreen?
    var currentUniverse : GameUniverse?
    let initialLives = 3
    
    var level = 0
    var lives = 3
    let enemiesPerLevel    = [2,4,5,6,7, 8,10,12,14,16, 18,20,22,24,26, 28,30,32]
    let friendliesPerLevel = [16,16,15,14,13, 12,11,10,8,8, 8,8,8,8,8, 8,8,8]
    
    let playing = Playing()
    let gameOver = GameOver()
    let attract = Attract()
    
    required init(_ view: SKView, gameDelegate: GameDelegate) {
        super.init(states: [playing, gameOver, attract])
        self.gameDelegate = gameDelegate
        scenekitView = view
    }
    
    class Playing : GKState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == GameOver.self
        }
    }
    class GameOver : GKState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == Attract.self
        }
    }
    class Attract : GKState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == Playing.self
        }
    }
    
    func begin() {
        _ = enter(Attract.self)
    }
    
    func onePlayerStart() {
        _ = enter(Playing.self)
    }
    
    override func enter(_ stateClass: AnyClass) -> Bool {
        let ret = super.enter(stateClass)
        if(ret) {
            switch(stateClass) {
            case is Playing.Type:
                level = 0
                lives = initialLives
                nextLevel()
                break
            case is GameOver.Type:
                currentUniverse?.showGameOverLabel {
                    _ = self.enter(Attract.self)
                }
                break
            default: // attract
                let att = AttractScreen()
                att.attractScreenDelegate = self
                attractScreen = att
                if let view = scenekitView {
                    view.presentScene(att, transition: SKTransition.reveal(with: .down, duration: 0.5))
                }
                break
            }
        }
        return ret
    }
    
    func levelOver(_ universe: GameUniverse) {
        if let sm = universe.stateMachine, let state = sm.currentState {
            switch (state) {
            case sm.won:
                nextLevel()
                break
            case sm.lost:
                lives -= 1
                if(lives == 0) {
                    _ = enter(GameOver.self)
                } else {
                    universe.showLivesRemainingLabel(lives) {
                        self.startCurrentLevel()
                    }
                }
                break
            default:
                break
            }
        }
    }
    
    func nextLevel() {
        level += 1
        startCurrentLevel()
    }
    
    func startCurrentLevel() {
        var levelElement = level - 1
        if(levelElement >= enemiesPerLevel.count) {
            levelElement = enemiesPerLevel.count - 1
        }
        if let view = scenekitView {
            let newUniverse = GameUniverse(size: view.bounds.size)
            newUniverse.stateMachine.levelDelegate = self
            newUniverse.friendlyCount = friendliesPerLevel[levelElement]
            newUniverse.enemyCount = enemiesPerLevel[levelElement]
            if let u = currentUniverse {
                newUniverse.playerOne.controller = u.playerOne.controller
                newUniverse.playerTwo.controller = u.playerTwo.controller
            }
            view.presentScene(newUniverse, transition: SKTransition.reveal(with: .down, duration: 0.5))
            GameUniverse.shared = newUniverse
            currentUniverse = newUniverse
        }
    }
    
    
    
    func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if let level = currentUniverse {
            level.pressesBegan(presses, with: event)
        } else if let attract = attractScreen {
            attract.pressesBegan(presses, with: event)
        }
    }
    
}

