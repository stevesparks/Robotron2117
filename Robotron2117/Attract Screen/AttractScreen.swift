//
//  AttractScreen.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/15/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

protocol AttractScreenDelegate : NSObjectProtocol {
    func onePlayerStart()
}

class AttractContext : WalkContext {
    
}

class AttractScreen: GameUniverse {

    weak var attractScreenDelegate : AttractScreenDelegate?
    
    convenience init() {
        self.init(size: UIScreen.main.bounds.size)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        setupAttract()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAttract()
    }

    func setupAttract() {
        let title = SKLabelNode(text: "Nerdotron:2117")
        title.fontName = UIFont.customFontName
        title.fontSize = 100
        title.fontColor = UIColor.white
        title.color = UIColor.clear
        title.zPosition = 30
        let sz = self.frame.size
        title.position = CGPoint(x: self.frame.midX, y: sz.height*0.83)
        addChild(title)

        let repoURL = SKLabelNode(text: "http://github.com/stevesparks/Robotron2117")
        repoURL.fontName = "Helvetica"
        repoURL.fontSize = 35
        repoURL.fontColor = UIColor.white
        repoURL.color = UIColor.clear
        repoURL.zPosition = 30
        repoURL.position = CGPoint(x: self.frame.midX, y: sz.height*0.1)

        repoURL.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: 0.025, duration: 0.1), SKAction.rotate(byAngle: -0.05, duration: 0.2), SKAction.rotate(byAngle: 0.025, duration: 0.1)])))
        addChild(repoURL)


        let subtitle = SKLabelNode(text: "PRESS PLAY TO BEGIN")
        subtitle.fontName = UIFont.customFontName
        subtitle.fontSize = 35
        subtitle.fontColor = UIColor.white
        subtitle.color = UIColor.clear
        subtitle.zPosition = 30
        subtitle.position = CGPoint(x: self.frame.midX, y: sz.height*0.75)
        
        subtitle.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.5), SKAction.scale(to: 0.91, duration: 0.5)])))
        addChild(subtitle)
        
        self.friendlyCount = 20
        self.enemyCount = 1
        self.level = 0
        _ = stateMachine.enter(GameStateMachine.Playing.self)

        let scores = HighScoresNode()
        scores.zPosition = 100
        let ctr = self.frame.center
        scores.position = CGPoint(x: ctr.x, y: ctr.y - 200)
        addChild(scores)
        scores.populate()
    }
    
    override func allDead() -> Bool {
        return false
    }
    
    override func addEnemies() {
        
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if let type = presses.first?.type , (type == .playPause || type == .select) {
            self.stopGame()
            attractScreenDelegate?.onePlayerStart()
        }
    }
    
    override func addPlayer() {
        playerOne = DemoPlayer()
        super.addPlayer()
    }
    
}

class DemoPlayer : Player {
    class DemoContext : PlayerContext {
        override func walk() { }
    }

    override func setupPlayer() {
        super.setupPlayer()
        self.walkContext = DemoContext(self)
    }
    override func shoot() -> Bullet? {
        return nil
    }
}




extension UIFont {
    static var customFontName : String { return "Robotaur" }
    static var customFont : UIFont { return UIFont(name: customFontName, size: 48)! }
    
    static var highScoreFontName : String { return "Pixeled" }
    static var highScoreFont : UIFont {
        return UIFont(name: highScoreFontName, size: 20)!
    }
    
}
