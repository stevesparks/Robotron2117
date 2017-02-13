//
//  ExtendedGamepadControl.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/12/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import GameController

class ExtendedGamepadControl: Control {
    let controller : GCController
    let pad : GCExtendedGamepad
    
    var priority: Int {
        return 10
    }

    var valueChangedBlock: ((CGVector, CGVector) -> Void)?
    
    init(_ controller : GCController) {
        self.controller = controller
        self.pad = controller.extendedGamepad!
        
        pad.valueChangedHandler = { pad in
            self.readPad()
        }
    }
    
    var moveVector : CGVector {
        return CGVector(dx: Double(pad.leftThumbstick.xAxis.value),
                        dy: Double(pad.leftThumbstick.yAxis.value))
    }
    
    var shootVector : CGVector {
        return CGVector(dx: Double(pad.rightThumbstick.xAxis.value),
                        dy: Double(pad.rightThumbstick.yAxis.value))
    }
    
    func readPad() {
        if let blk = valueChangedBlock {
            blk(moveVector, shootVector)
        }
    }
    
    var trigger: Bool {
        return (pad.buttonB.isPressed || pad.rightTrigger.isPressed || pad.leftTrigger.isPressed)
    }

}
