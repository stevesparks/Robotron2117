//
//  AttractScreen.swift
//  Robotron2117
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
        let title = SKLabelNode(text: "ROBOTRON 2117")
        title.fontName = UIFont.customFontName
        title.fontSize = 100
        title.fontColor = UIColor.white
        title.color = UIColor.clear
        let sz = self.frame.size
        title.position = CGPoint(x: sz.width/2.0, y: sz.height*0.65)
        addChild(title)

        let subtitle = SKLabelNode(text: "PRESS PLAY TO BEGIN")
        subtitle.fontName = UIFont.customFontName
        subtitle.fontSize = 35
        subtitle.fontColor = UIColor.white
        subtitle.color = UIColor.clear
        subtitle.position = CGPoint(x: sz.width/2.0, y: sz.height*0.5)
        
        subtitle.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.5), SKAction.scale(to: 0.91, duration: 0.5)])))
        addChild(subtitle)
        
        self.friendlyCount = 20
        self.enemyCount = 1
        self.level = 0
        _ = stateMachine.enter(GameStateMachine.Playing.self)
    }

    override func allDead() -> Bool {
        return false
    }
    
    override func addEnemies() {
        
    }
    
    override func addPlayer() {
        
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if let type = presses.first?.type , type == .playPause {
            attractScreenDelegate?.onePlayerStart()
        }
    }
    
}

extension UIFont {
    static var customFontName : String { return "Robotaur" }
    static var customFont : UIFont { return UIFont(name: customFontName, size: 48)! }
}
