//
//  GameUniverse+Controllers.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/13/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit
import GameController

extension GCController {
    func player() -> Player? {
        if GameUniverse.shared.playerOne.controller?.controller == self {
            return GameUniverse.shared.playerOne
        }
        if GameUniverse.shared.playerTwo.controller?.controller == self {
            return GameUniverse.shared.playerTwo
        }
        return nil
    }
}

extension GameUniverse {
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
        
        if let prio = playerOne.controller?.priority, prio > control.priority {
            // replacing the existing controller with the new one
            playerOne.controller = control
        } else if playerOne.controller == nil {
            // setting it is easy
            playerOne.controller = control
        } else {
            // a second player!!
            
        }
        controllers.append(controller)
    }
    
    func removeController(_ controller: GCController) {
        if playerOne.controller?.controller == controller {
            
        } else if playerTwo.controller?.controller == controller {

        }
        if let idx = controllers.index(of: controller) {
            controllers.remove(at: idx)
        }
    }
}
