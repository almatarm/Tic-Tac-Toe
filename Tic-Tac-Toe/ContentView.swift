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
                            board.setSquare(forIndex: i)
                        }
                    }
                })
                
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
    
    init(initPlayer: Player) {
        self.player = initPlayer
    }
    
    func isSquareOccupied(forIndex index: Int) -> Bool {
        return moves[index] != nil
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
    
}
