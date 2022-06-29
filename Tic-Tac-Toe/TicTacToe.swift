//
//  TicTacToe.swift
//  Tic-Tac-Toe
//
//  Created by Mufeed AlMatar on 30/11/1443 AH.
//

import Foundation

struct TicTacToe {
    
    enum Status {
        case humanWin, computerWin, draw, inProgress
    }
    
    private var moves: [Move?] = Array(repeatElement(nil, count: 9))
    private var initPlayer: Player
    private var player: Player = .human
    var isBoardDisbled: Bool = false
    var winner: Player? = nil
    var activeGame = false
    var status: Status = .inProgress
    
    init(initPlayer: Player) {
        self.initPlayer = initPlayer
        restGame()
    }
    
    mutating func restGame() {
        player = initPlayer
        isBoardDisbled = initPlayer == .computer
        moves = Array(repeatElement(nil, count: 9))
        winner = nil
        activeGame = true
        status = .inProgress
    }
    
    func isSquareOccupied(forIndex index: Int) -> Bool {
        return moves[index] != nil
    }
    
    mutating func humanMove(forIndex index: Int) -> Bool {
        let success = activeGame && setSquare(forIndex: index)
        if success { afterSuccssfullMove() }
        return success
    }
    
    mutating func computerMove() -> Bool {
        let success = activeGame && setSquare(forIndex: determineComputerNextMove())
        if success { afterSuccssfullMove() }
        return success
    }
    
    private mutating func afterSuccssfullMove() {
        winner = checkWinCondition() ? player : nil
        if (winner != nil) {
            activeGame = false
            status = player == .human ? .humanWin : .computerWin
            print("Winner is \(player)")
            return
        }
        
        if(checkForDraw()) {
            activeGame = false
            status = .draw
            print("Draw")
            return
        }
        
        isBoardDisbled.toggle()
        player = player == .human ? .computer : .human
    }
    
    mutating func setSquare(forIndex index: Int) -> Bool {
        if isSquareOccupied(forIndex: index) {
            return false
        }
        moves[index] = Move(player: player, boardIndex: index)
        return true
    }
    
    func indicator(forIndex index: Int) -> String {
        return moves[index]?.indicator ?? ""
    }
    
    func determineComputerNextMove() -> Int {
        let emptySquaresIndecies = findEmptySquares()
        if(emptySquaresIndecies.isEmpty) {
            return -1
        }
        return emptySquaresIndecies.randomElement()!
    }
    
    func findEmptySquares() -> [Int] {
        var indecies: [Int]  = []
        for (index, move) in moves.enumerated() {
            if move == nil {
                indecies.append(index)
            }
        }
        return indecies
    }
    
    func checkWinCondition() -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoveIndices = Set( moves.compactMap{ $0 }
            .filter { $0.player ==  player }
            .map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerMoveIndices) {
            return true
        }
        
        return false
    }
    
    func checkForDraw() -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
