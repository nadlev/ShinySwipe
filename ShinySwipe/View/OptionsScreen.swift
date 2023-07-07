//
//  OptionsScreen.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import StoreKit
import SwiftUI

struct OptionsScreen: View {
    @Binding var username: String
    
    @Binding var boardSize: Int
    @ObservedObject var game: GameEngine
    @ObservedObject var iapManager: IAPManager
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("PROFILE", comment: ""))) {
                    TextField(NSLocalizedString("Username", comment: ""), text: $username)
                }
                
                Section(header: Text(NSLocalizedString("GAMEOPTIONS", comment: ""))) {
                    Stepper(value: $boardSize, in: 3...8) {
                        Text(NSLocalizedString("Boardsize", comment: ""))
                        Spacer()
                        Text("\(boardSize) x \(boardSize)")
                    }
                    .disabled(iapManager.isPremiumUser == false && boardSize > 3)
                    Button(action: {
                        if iapManager.isPremiumUser || boardSize == 3 {
                            game.boardSize = boardSize
                            game.state = .start
                        } else {
                            showingAlert = true
                        }
                    }, label: {
                        Text(NSLocalizedString("StartNewGame", comment: ""))
                    })
                }
            }
            .navigationBarTitle(NSLocalizedString("Settings", comment: ""))
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Premium Required"),
                    message: Text("Unlock larger board sizes with premium subscription"),
                    primaryButton: .default(Text("Buy Premium")) {
                        iapManager.buyProduct(productId: "premium")
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct OptionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        OptionsScreen(username: .constant("username"), boardSize: .constant(3), game: GameEngine(), iapManager: IAPManager())
    }
}

