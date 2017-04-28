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
        return pad.leftThumbstick.vector
    }
    
    var dpadVector : CGVector {
        return pad.dpad.vector
    }
    
    var moveVector : CGVector {
        let thumb = leftThumbstickVector
        print("thumb \(thumb)");
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

extension GCControllerDirectionPad {
    var vector : CGVector {
        return CGVector(dx: Double(xAxis.value),
                        dy: Double(yAxis.value))
    }
}
