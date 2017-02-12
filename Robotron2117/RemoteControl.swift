//
//  RemoteControl.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameController

class RemoteControl: Control {
    let pad : GCMicroGamepad
    
    var valueChangedBlock: ((CGVector, CGVector) -> Void)?
    
    init(_ pad : GCMicroGamepad) {
        self.pad = pad
        
        pad.valueChangedHandler = { pad in
            self.readPad()
        }
    }

    var moveVector : CGVector {
        return CGVector(dx: Double(pad.dpad.xAxis.value),
                        dy: Double(pad.dpad.yAxis.value))
    }

    var shootVector : CGVector {
        var shootVector : CGVector = .zero
        if let motion = pad.controller?.motion {
            let acc = motion.gravity
            shootVector = CGVector(dx: acc.x, dy: 0-acc.y)
        }
        return shootVector
    }
    
    func readPad() {
        if let blk = valueChangedBlock {
            blk(moveVector, shootVector)
        }
    }
    
    var trigger: Bool {
        return (pad.buttonA.isPressed || pad.buttonX.isPressed)
    }
}
