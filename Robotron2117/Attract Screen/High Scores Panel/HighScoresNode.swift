
//
//  HighScoresNode.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/17/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class HighScoresNode: SKNode {
    
    override required init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func move(toParent parent: SKNode) {
        super.move(toParent: parent)
        populate()
    }
    
    var highScoresLabel : SKLabelNode = {
        let lbl = SKLabelNode()
        lbl.fontColor = UIColor.white
        lbl.text = "HIGH SCORES"
        lbl.fontSize = 24
        lbl.fontName = UIFont.highScoreFontName
        return lbl
    }()

    func convert(_ point : CGPoint) -> CGPoint {
        guard let parent = parent else {
            return point
        }
        return parent.convert(point, from: parent)
    }
    
    func populate() {
        if highScoresLabel.parent != nil {
            self.removeAllChildren()
        }
        
        self.highScoresLabel.position = convert(CGPoint(x: 0, y:370.0))
        LeaderboardManager.shared.scores() { scores in
            var y = 300
            self.addChild(self.highScoresLabel)
            for score in scores {
                let node = ScoreNode(score.rank, score: score)
                node.position = CGPoint(x: 0, y: y)
                y -= 50
                self.addChild(node)
            }
            var x = scores.count + 1
            while x <= 10 {
                let score = DummyScore()
                score.rank = x
                let node = ScoreNode(x, score: score)
                node.position = CGPoint(x: 0, y: y)
                y -= 50
                self.addChild(node)
                x += 1
            }
        }
    }
}
