//
//  RemoteControl.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameController

class RemoteControl: Control {
    let controller : GCController
    let pad : GCMicroGamepad
    
    var valueChangedBlock: ((CGVector, CGVector) -> Void)?
    
    var priority: Int {
        return 20
    }
    
    init(_ controller : GCController) {
        self.controller = controller
        self.pad = controller.microGamepad!
        
        pad.valueChangedHandler = { pad in
            self.readPad()
        }
    }

    var moveVector : CGVector {
        return CGVector(dx: Double(pad.dpad.xAxis.value),
                        dy: Double(pad.dpad.yAxis.value)).simplifiedVector
    }

    var shootVector : CGVector {
        var shootVector : CGVector = .zero
        if let motion = pad.controller?.motion {
            let acc = motion.gravity
            shootVector = CGVector(dx: acc.x, dy: 0-acc.y).simplifiedVector
        }
        return shootVector
    }
    
    func readPad() {
        if let blk = valueChangedBlock {
            blk(moveVector, shootVector)
        }
    }
    
    var buttonAPressed: Bool {
        return pad.buttonA.isPressed
    }
    var trigger: Bool {
        return (pad.buttonA.isPressed || pad.buttonX.isPressed)
    }
}
