//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Mufeed AlMatar on 30/11/1443 AH.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var board: TicTacToe = TicTacToe(initPlayer: .human)
    @Published var alertItem: AlertItem?
    
    let columns: [GridItem] = [ GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    func processPlayersMoves(for position: Int) {
        board.humanMove(forIndex: position)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            board.computerMove()
            alertItem = checkGameStatusAndUpdateAlert()
        }
    }
    
    func checkGameStatusAndUpdateAlert() -> AlertItem? {
        switch board.status {
        case .humanWin: return AlertContext.humanWin
        case .computerWin: return AlertContext.computerWin
        case .draw: return AlertContext.draw
        case .inProgress: return nil
        }
    }
}
