//
//  ControllerManager.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/18/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import GameController

extension GCController {
    func player() -> Player? {
        if ControllerManager.shared.playerOneController?.controller == self {
            return GameUniverse.shared.playerOne
        }
        if ControllerManager.shared.playerTwoController?.controller == self {
            return GameUniverse.shared.playerTwo
        }
        return nil
    }
}

class ControllerManager {
    static let shared = ControllerManager()
    
    enum ControllerManagerState {
        case new
        case looking
        case shutdown
    }
    
    var state : ControllerManagerState = .new
        
    var controllers = [GCController]()
    var unusedControllers = [GCController]()
    
    var playerOneController : Control?
    var playerTwoController : Control?

    func startWatchingForControllers() {
        if state == .looking {
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ControllerManager.notifyAdd), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ControllerManager.notifyRemove), name: .GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery(completionHandler: {})
        state = .looking
    }
    
    func stopWatchingForControllers() {
        state = .shutdown
        GCController.stopWirelessControllerDiscovery()
    }
    
    @objc func notifyAdd(_ note: Notification) {
        if let ctrl = note.object as? GCController {
            addController(ctrl)
        }
    }
    
    @objc func notifyRemove(_ note: Notification) {
        if let ctrl = note.object as? GCController {
            removeController(ctrl)
        }
    }
    
    func addController(_ controller: GCController) {
        var control : Control!
        
        if controller.extendedGamepad != nil {
            control = ExtendedGamepadControl(controller)
        } else if controller.microGamepad != nil {
            control = RemoteControl(controller)
        } else {
            return
        }
        
        if let prio = playerOneController?.priority, prio > control.priority {
            // replacing the existing controller with the new one
            playerOneController = control
            controller.playerIndex = .index1
        } else if playerOneController == nil {
            // setting it is easy
            playerOneController = control
            controller.playerIndex = .index1
//        } else if let prio = playerTwoController?.priority, prio > control.priority {
//            playerTwoController = control
//            controller.playerIndex = .index2
//        } else if playerTwoController == nil {
//            playerTwoController = control
//            controller.playerIndex = .index2
        } else {
            // a second player!!
            controller.playerIndex = .indexUnset
            unusedControllers.append(controller)
        }
        controllers.append(controller)
    }
    
    func removeController(_ controller: GCController) {
        if playerOneController?.controller == controller {
            playerOneController = nil
            dequeueUnusedController()
        } else if playerTwoController?.controller == controller {
            playerTwoController = nil
            dequeueUnusedController()
        }
        if let idx = controllers.index(of: controller) {
            controllers.remove(at: idx)
        }
    }
    
    func dequeueUnusedController() {
        if let ctrl = unusedControllers.first {
            unusedControllers.remove(at: 0)
            addController(ctrl) // Attempt to attach it to a player; if not, add it back to the end of the controllers list.
        }
    }
}
