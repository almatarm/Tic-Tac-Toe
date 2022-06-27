//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Mufeed AlMatar on 28/11/1443 AH.
//

import SwiftUI

struct ContentView: View {
    
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
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
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
