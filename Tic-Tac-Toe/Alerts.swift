//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Mufeed AlMatar on 29/11/1443 AH.
//

import SwiftUI

struct AlertItem : Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin    = AlertItem(title: Text("You win!"),
                                message: Text("You beat your own AI"),
                                buttonTitle: Text("Oh yeah"))
    
    static let computerWin = AlertItem(title: Text("You lost!"),
                                message: Text("Your own AI beat you!!"),
                                buttonTitle: Text("Oh yeah"))
    
    static let draw        = AlertItem(title: Text("Draw!"),
                                message: Text("Play agian!"),
                                buttonTitle: Text("Oh yeah"))
}
