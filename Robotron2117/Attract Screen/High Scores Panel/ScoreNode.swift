//
//  HighScoreNode.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/17/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit
import GameKit

protocol Displayable {
    var name : String? { get }
    var isMe : Bool { get }
}
protocol Scorable {
    var rank: Int { get }
    var value: Int64 { get }
    var displayable : Displayable? { get }
}

extension GKPlayer : Displayable {
    var name : String? {
        return self.alias
    }
    var isMe : Bool {
        return "Me" == self.displayName
    }
}
extension GKScore : Scorable {
    internal var displayable: Displayable? {
        return player
    }
}


class DummyScore : Scorable {
    var displayable : Displayable? = DummyName()
    var rank : Int = 1
    var value : Int64 = 0
    class DummyName : Displayable {
        var isMe = false
        var name: String? {
            get {
                return "THIS COULD BE YOU"
            }
        }
    }
    
}

class ScoreNode: SKNode {
    var place : Int
    var score : Scorable
    
    var placeLabel : SKLabelNode = {
        let lbl = SKLabelNode()
        lbl.fontColor = UIColor.white
        lbl.horizontalAlignmentMode = .left
        lbl.fontName = UIFont.highScoreFontName
        lbl.fontSize = 18
        return lbl
    }()
    var nameLabel : SKLabelNode = {
        let lbl = SKLabelNode()
        lbl.fontColor = UIColor.red
        lbl.horizontalAlignmentMode = .left
        lbl.fontName = UIFont.highScoreFontName
        lbl.fontSize = 18
        return lbl
    }()
    let scoreLabel : SKLabelNode = {
        let lbl = SKLabelNode()
        lbl.fontColor = UIColor.green
        lbl.horizontalAlignmentMode = .right
        lbl.fontName = UIFont.highScoreFontName
        lbl.fontSize = 18
        return lbl
    }()
    
    
    func convert(_ point : CGPoint) -> CGPoint {
        guard let parent = parent else {
            return point
        }
        return parent.convert(point, from: parent)
    }

    
    required init(_ place: Int, score: Scorable) {
        self.place = place
        self.score = score
        super.init()
        populate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate() {
        placeLabel.position = convert(CGPoint(x: -360, y: 5))
        addChild(placeLabel)

        nameLabel.position = convert(CGPoint(x: -290, y: 5))
        addChild(nameLabel)

        scoreLabel.position = convert(CGPoint(x: 400, y: 5))
        addChild(scoreLabel)
        
        
        placeLabel.text = "\(score.rank)"
        nameLabel.text = score.displayable?.name?.uppercased()
        if (score.displayable?.isMe ?? false) {
            nameLabel.fontColor = UIColor.yellow
        }
        scoreLabel.text = "\(score.value)"
    }
}
