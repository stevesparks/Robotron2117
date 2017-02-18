//
//  Options.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/17/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Options {
    static var adminMode : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "AdminMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AdminMode")
        }
    }
}
