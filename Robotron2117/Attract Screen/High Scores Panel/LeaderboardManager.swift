//
//  LeaderboardManager.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/17/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import GameKit

typealias LeaderboardResultsBlock = ([GKScore]) -> Void

class LeaderboardManager {
    var me : GKLocalPlayer!

    weak var rootViewController : UIViewController?
    
    var board : GKLeaderboard?
    var scores = [GKScore]()
    var isReady = false
    
    var notifyBlocks = [LeaderboardResultsBlock]()
    static var shared = LeaderboardManager()
    
    init() {
        authenticate()
    }
    
    func authenticate() {
        me = {
            let x = GKLocalPlayer.localPlayer()
            x.authenticateHandler = { vc, error in
                if let vc = vc {
                    print("\(vc)")
                    if let root = self.rootViewController {
                        root.present(vc, animated: true)
                    }
                } else if let error = error {
                    print("\(error)")
                }
            }
            print("Me: \(x.debugDescription)")
            return x
        }()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(GKPlayerAuthenticationDidChangeNotificationName), object: nil, queue: OperationQueue.main, using: { _ in
            print("Updated! \(self.me.debugDescription)")
            print("\(LeaderboardManager.shared)")
            self.getBoard()
        })
    }
    
    public func getBoard() {
        GKLeaderboard.loadLeaderboards() { boards, error in
            if let error = error {
                print("Error loading leaderboard: \(error)")
            } else if let boards = boards, boards.count > 0 {
                if let board = boards.first {
                    self.board = board
                    self.loadScores()
                }
            }
        }
    }
    
    func loadScores(_ completion: @escaping () -> Void = {}) {
        isReady = false
        self.board?.loadScores() { scores, error in
            if let error = error {
                print("Error loading leaderboard: \(error)")
            } else if let scores = scores {
                self.scores = scores
                self.isReady = true
                self.executeBlocksWhenReady()
            } else {
                self.isReady = true
                self.executeBlocksWhenReady()
            }
            completion()
        }
    }
    
    func executeBlocksWhenReady() {
        guard isReady == true else {
            return
        }
        for block in notifyBlocks {
            block(scores)
        }
        notifyBlocks.removeAll()
    }
    func report(_ score: Int, completion: @escaping () -> Void = {}) {
        guard let board = board, let ident = board.identifier else {
            return
        }
        let newScore = GKScore(leaderboardIdentifier: ident)
        newScore.value = Int64(score)
        GKScore.report([newScore]) { error in
            if let error = error {
                print("NEW SCORE ERROR \(error)")
            } else {
                self.loadScores(completion)
            }
        }
    }
    
    func scores(_ completion: @escaping LeaderboardResultsBlock) {
        if(isReady) {
            completion(scores)
        } else {
            notifyBlocks.append(completion)
            executeBlocksWhenReady()
        }
    }


}
