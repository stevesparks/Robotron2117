//
//  ExtendedGamepadControl.swift
//  Nerdotron2117
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
    
    var leftThumbstickVector : CGVector {
        return CGVector(dx: Double(pad.leftThumbstick.xAxis.value),
                        dy: Double(pad.leftThumbstick.yAxis.value))
    }
    
    var dpadVector : CGVector {
        return CGVector(dx: Double(pad.dpad.xAxis.value),
                        dy: Double(pad.dpad.yAxis.value))
    }
    
    var moveVector : CGVector {
        let thumb = leftThumbstickVector
        if thumb == .zero {
            return dpadVector.simplifiedVector
        }
        return thumb.simplifiedVector
    }
    
    var buttonAPressed: Bool {
        return pad.buttonA.isPressed
    }

    var shootVector : CGVector {
        return CGVector(dx: Double(pad.rightThumbstick.xAxis.value),
                        dy: Double(pad.rightThumbstick.yAxis.value)).simplifiedVector
    }
    
    func readPad() {
        if let blk = valueChangedBlock {
            blk(moveVector, shootVector)
        }
    }
    
    var trigger: Bool {
        return shootVector != .zero
//        return (pad.buttonB.isPressed || pad.rightTrigger.isPressed || pad.leftTrigger.isPressed)
    }

}
