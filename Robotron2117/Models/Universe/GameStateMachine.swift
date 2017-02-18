//
//  GameStateMachine.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/15/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import GameplayKit
import GameController

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
    
    var playerOneController : Control?
    var playerTwoController : Control?
    var benchedController : [Control] = []
    
    var level = 0
    var lives = 3

    let levels = GameLevel.baseLevels
    
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
                attractScreen?.run(SKAction.playSoundFileNamed("robo-start.wav", waitForCompletion: false))
                attractScreen = nil
                level = 0
                lives = initialLives
                nextLevel()
                break
            case is GameOver.Type:
                if let univ = currentUniverse {
                    let finalScore = univ.score
                    LeaderboardManager.shared.report(finalScore) {
                        univ.showGameOverLabel {
                            _ = self.enter(Attract.self)
                        }
                    }
                }
                break
            default: // attract
                let att = AttractScreen()
                att.attractScreenDelegate = self
                attractScreen = att
                currentUniverse = nil
                if let view = scenekitView {
                    view.presentScene(att, transition: SKTransition.doorsOpenHorizontal(withDuration:  0.5))
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
                universe.tallyRemainingFriendlies {
                    self.nextLevel()
                }
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
        if(levelElement >= levels.count) {
            levelElement = levels.count - 1
        }
        if let view = scenekitView {
            let levelDescriptor = levels[levelElement]
            let newUniverse = GameUniverse(size: view.bounds.size)
            newUniverse.stateMachine.levelDelegate = self
            newUniverse.friendlyCount = levelDescriptor.numberOfFriendlies
            newUniverse.enemyCount = levelDescriptor.numberOfFootSoldiers
            newUniverse.score = currentUniverse?.score ?? 0
            newUniverse.livesLeft = lives
            newUniverse.level = level
            view.presentScene(newUniverse, transition: SKTransition.doorsOpenHorizontal(withDuration:  0.5))
            GameUniverse.shared = newUniverse
            currentUniverse = newUniverse
            assignControllers()
        }
    }
    
    func assignControllers() {
        if let universe = currentUniverse {
            universe.playerOne.controller = playerOneController
            universe.playerTwo.controller = playerTwoController
        } else if attractScreen != nil {
        }
    }
    
    func addController(_ controller: GCController) {
        var control : Control!
        if controller.microGamepad != nil,
            controller.extendedGamepad == nil {
            control = RemoteControl(controller)
        } else if controller.extendedGamepad != nil {
            control = ExtendedGamepadControl(controller)
        } else {
            return
        }
        
        if let prio = playerOneController?.priority, prio > control.priority {
            // replacing the existing controller with the new one
            playerOneController = control
            assignControllers()
        } else if playerOneController == nil {
            // setting it is easy
            playerOneController = control
            assignControllers()
        } else {
            // a second player!!
        }
    }
    
    func removeController(_ controller: GCController) {
        if playerOneController?.controller == controller, let playerOne = currentUniverse?.playerOne {
            playerOne.controller = nil
            playerOneController = nil
        } else if playerTwoController?.controller == controller, let playerTwo = currentUniverse?.playerTwo {
            playerTwo.controller = nil
            playerTwoController = nil
        }
    }

    
    func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if let attract = attractScreen {
            attract.pressesBegan(presses, with: event)
        } else if let level = currentUniverse {
            level.pressesBegan(presses, with: event)
        }
    }
    
}
