//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Mufeed AlMatar on 28/11/1443 AH.
//

import SwiftUI

struct GameView: View {
    @StateObject var gameVM = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: gameVM.columns, spacing: 10, content: {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquare(proxy: geometry)
                            GameSquareIndicator(imageName: gameVM.board.indicator(forIndex: i))
                        }
                        .onTapGesture {
                            gameVM.processPlayersMoves(for: i)
                        }
                    }
                })
                .disabled(gameVM.board.isBoardDisbled)
                Spacer()
            }
            .padding()
            .alert(item: $gameVM.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {
                        gameVM.board.restGame()
                      }))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameSquare: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
            .opacity(0.5)
            .cornerRadius(25)
            .frame(width: proxy.size.width/3 - 25,
                   height: proxy.size.width/3 - 25)
    }
}

struct GameSquareIndicator: View {
    var imageName: String
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .frame(width: 35, height: 35)
            .foregroundColor(.white)
    }
}
