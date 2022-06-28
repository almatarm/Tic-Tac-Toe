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
    
    init(initPlayer: Player) {
        self.player = initPlayer
        self.isBoardDisbled = initPlayer == .computer
    }
    
    func isSquareOccupied(forIndex index: Int) -> Bool {
        return moves[index] != nil
    }
    
    mutating func humanMove(forIndex index: Int) -> Bool {
        let success = setSquare(forIndex: index)
        if success {
            isBoardDisbled.toggle()
        }
        return success
    }
    
    mutating func computerMove() -> Bool {
        let success = setSquare(forIndex: determineComputerNextMove())
        if success {
            isBoardDisbled.toggle()
        }
        return success
    }
    
    mutating func setSquare(forIndex index: Int) -> Bool {
        if isSquareOccupied(forIndex: index) {
            return false
        }
        moves[index] = Move(player: player, boardIndex: index)
        player = player == .human ? .computer : .human
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
        let i = emptySquaresIndecies.randomElement()!
        print(i)
        return i
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
    
    
}
