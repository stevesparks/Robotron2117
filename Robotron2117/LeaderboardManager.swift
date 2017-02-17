//
//  LeaderboardManager.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/17/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import GameKit

class LeaderboardManager {
    var board : GKLeaderboard?
    
    var isReady = false
    
    static var shared = LeaderboardManager()
    
    init() {
        getBoard()
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
    
    func loadScores() {
        print("BOARD: \(self.board)")
        self.board?.loadScores() { scores, error in
            if let error = error {
                print("Error loading leaderboard: \(error)")
            } else if let scores = scores {
                print("SCORES: \(scores)")
                self.isReady = true
            } else {
                print("NO BOARD, NO SCORES")
                self.isReady = true
            }
        }
    }
    
    
    func report(_ score: Int) {
        guard let board = board, let ident = board.identifier else {
            return
        }
        let newScore = GKScore(leaderboardIdentifier: ident)
        newScore.value = Int64(score)
        GKScore.report([newScore]) { error in
            if let error = error {
                print("NEW SCORE ERROR \(error)")
            }
        }
    }
    


}
