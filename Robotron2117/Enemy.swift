//
//  Enemy.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class Enemy: Hittable {

    
    override func walk() {
        let vec = directionToNearestPlayer()
        var pos = self.position
        pos.x = pos.x + (vec.dx * 5)
        pos.y = pos.y + (vec.dy * 5)
        self.position = pos
    }

}
