//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Mufeed AlMatar on 28/11/1443 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var board: TicTacToe = TicTacToe(initPlayer: .human)
    
    let columns: [GridItem] = [ GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 10, content: {
                    ForEach(0..<9) { i in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.red)
                                .opacity(0.5)
                                .cornerRadius(25)
                                .frame(width: geometry.size.width/3 - 25,
                                       height: geometry.size.width/3 - 25)
                            
                            Image(systemName: board.indicator(forIndex: i))
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            board.humanMove(forIndex: i)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                board.computerMove()
                            }
                        }
                    }
                })
                .disabled(board.isBoardDisbled)
                Spacer()
            }
            .padding()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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

struct TicTacToe {
    private var moves: [Move?] = Array(repeatElement(nil, count: 9))
    private var player: Player
    var isBoardDisbled: Bool
    var winner: Player? = nil
    var activeGame = false
    
    init(initPlayer: Player) {
        self.player = initPlayer
        self.isBoardDisbled = initPlayer == .computer
        self.activeGame = true
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
            print("Winner is \(player)")
            return
        }
        
        if(checkForDraw()) {
            activeGame = false
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
