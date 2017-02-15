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

class AttractScreen: SKScene {

    weak var attractScreenDelegate : AttractScreenDelegate?
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == .playPause {
            attractScreenDelegate?.onePlayerStart()
        }
    }
    
}
