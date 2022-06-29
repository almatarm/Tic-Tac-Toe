//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Mufeed AlMatar on 28/11/1443 AH.
//

import SwiftUI

struct GameView: View {
    @State private var board: TicTacToe = TicTacToe(initPlayer: .human)
    @State private var alertItem: AlertItem?
    
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
                            let succuessMove = board.humanMove(forIndex: i)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                board.computerMove()
                                alertItem = checkGameStatusAndUpdateAlert()
                            }
                        }
                    }
                })
                .disabled(board.isBoardDisbled)
                Spacer()
            }
            .padding()
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {
                        board.restGame()
                      }))
            }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
