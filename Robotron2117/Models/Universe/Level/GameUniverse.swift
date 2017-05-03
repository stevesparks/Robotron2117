//
//  GameUniverse.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

enum CollisionType : UInt32 {
    case Player = 0x01
    case Enemy = 0x02
    case Bullet = 0x08
    case Wall = 0x10
    case Civilian = 0x20
}

class GameNode : SKSpriteNode {
    var universe : GameUniverse {
        return GameUniverse.shared
    }
}

class GameUniverse: SKScene {
    static var shared = GameUniverse(size: CGSize(width: 1920, height: 1080))
    
    var stateMachine : GameLevelStateMachine!
    var speedModifier : CGFloat = 1.0
    var scoring : Bool = true

    var playfieldFrame : CGRect {
        return CGRect(x: screenBorderWidth, y: screenBorderWidth, width: frame.size.width - (2*screenBorderWidth), height: frame.size.height - (2*screenBorderWidth))
    }

    var levelDescriptor: GameLevel {
        didSet {
            friendlyCount = levelDescriptor.numberOfFriendlies
            enemyCount = levelDescriptor.numberOfFootSoldiers
            if let boolVal = levelDescriptor.options["scoring"] as? Bool {
                scoring = boolVal
            }
        }
    }
    
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
    
    var enemyCount = GameLevel.demoLevel.numberOfFootSoldiers
    var barrierCount = 0
    var friendlyCount = GameLevel.demoLevel.numberOfFriendlies
    
    let enemySize = CGSize(width: 20, height: 20)
    let friendlySize = CGSize(width: 20, height: 20)
    let barrierSize = CGSize(width: 5, height: 30)
    static let playerSize = CGSize(width: 40, height: 40)
    
    let screenBorderWidth = CGFloat(50.0)
    
    var playerOne = Player()
    var playerTwo = Player()
    
    var friendlies : [Hittable] = []
    var enemies : [Enemy] = []
    var barriers : [Barrier] = []
    var enemyIndex : Int = 0

    convenience init(size: CGSize, level: GameLevel) {
        self.init(size: size)
        levelDescriptor = level
        friendlyCount = levelDescriptor.numberOfFriendlies
        enemyCount = levelDescriptor.numberOfFootSoldiers
    }

    override init(size: CGSize) {
        levelDescriptor = GameLevel.demoLevel
        super.init(size: size)
        stateMachine = GameLevelStateMachine(self)
        addChild(scoreLabel)
        addChild(livesLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        levelDescriptor = GameLevel.demoLevel
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
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == .playPause {
            if(tockTimer == nil) {
                startGame()
            } else {
                stopGame()
            }
        } else {
            super.pressesEnded(presses, with: event)
        }
    }
}

