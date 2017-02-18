//
//  GameUniverse.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit
import GameController

enum CollisionType : UInt32 {
    case Player = 0x01
    case Enemy = 0x02
    case Bullet = 0x08
    case Wall = 0x10
    case Civilian = 0x20
}

class GameNode : SKSpriteNode {
    weak var universe : GameUniverse!
}

class GameUniverse: SKScene {
    static var shared = GameUniverse(size: CGSize(width: 1920, height: 1080))
    
    var stateMachine : GameLevelStateMachine!
    var speedModifier = 1.0
    
    var scoreLabel : SKLabelNode = {
        let label = SKLabelNode(text: "")
        label.fontName = UIFont.customFontName
        label.fontSize = 36
        label.fontColor = UIColor.white
        label.position = CGPoint(x: 300, y: 70)
        label.zPosition = 1
        return label
    }()
    
    var livesLabel : SKLabelNode = {
        let label = SKLabelNode(text: "")
        label.fontName = UIFont.customFontName
        label.fontSize = 30
        label.fontColor = UIColor.black
        label.position = CGPoint(x: 1620, y: 70)
        label.zPosition = 1
        return label
    }()
    
    var controllers : [GCController] = []
    
    var level = 1
    var livesLeft = 0 {
        didSet {
            livesLabel.text = ""
            var lx = livesLeft
            
            while lx > 0 {
                livesLabel.text = livesLabel.text?.appending("🤖")
                lx -= 1
            }
        }
    }
    var score = 0 {
        willSet {
            if score != 0 {
                // free life every 10k. Are we passing over?
                let oldScoreLevel = score / 10000
                let newScoreLevel = newValue / 10000
                if oldScoreLevel != newScoreLevel {
                    bonusLife()
                }
            }
        }
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    var enemyCount = 20
    var barrierCount = 0
    var friendlyCount = 10
    
    let enemySize = CGSize(width: 20, height: 20)
    let friendlySize = CGSize(width: 20, height: 20)
    let barrierSize = CGSize(width: 5, height: 30)
    static let playerSize = CGSize(width: 40, height: 40)
    
    let screenBorderWidth = CGFloat(50.0)
    
    var playerOne : Player = Player()
    var playerTwo : Player = Player()
    
    var friendlies : [Hittable] = []
    var enemies : [Enemy] = []
    var barriers : [Barrier] = []
    var enemyIndex : Int = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        stateMachine = GameLevelStateMachine(self)
        addChild(scoreLabel)
        addChild(livesLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        stateMachine = GameLevelStateMachine(self)
        addChild(scoreLabel)
        addChild(livesLabel)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        resetUniverse()
    }
    
    var tockTimer : Timer?
    
    override func addChild(_ node: SKNode) {
        if let gameNode = node as? GameNode {
            gameNode.universe = self
        }
        super.addChild(node)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == .playPause {
            if(tockTimer == nil) {
                startGame()
            } else {
                stopGame()
            }
        } else {
            super.pressesBegan(presses, with: event)
        }
    }
}

