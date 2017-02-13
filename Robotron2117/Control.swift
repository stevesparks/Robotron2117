//
//  Control.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameController

protocol Control {
    // Vector 1 = movement direction
    // Vector 2 = gun direction
    var valueChangedBlock : ((CGVector, CGVector) -> Void)? { get set }
   
    var moveVector: CGVector { get }
    var shootVector: CGVector { get }
    
    var controller : GCController { get }
    
    var trigger : Bool { get }
    
    // lower number is higher priority
    var priority : Int { get }
}
