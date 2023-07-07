//
//  ContentView.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import SwiftUI

//struct PopupView: View {
//    let score: Int
//
//    var body: some View {
//        VStack {
//            Text("Wow, keep it up!")
//                .font(.system(size: 17, design: .serif))
//                .bold(true)
//            Text("You have reached \(score)")
//                .font(.system(size: 16, design: .serif))
//                .bold(true)
//        }
//        .frame(width: 200, height: 180)
//        .background(Color.shadowGray)
//        .cornerRadius(10)
//        .shadow(color: Color("Pink"), radius: 10)
//    }
//}

struct MainScreen: View {
    @ObservedObject var game = GameEngine()
    
    @State var splashActive: Bool = true
    @State var showStartButton: Bool = false
    @State private var showPopup = false

    @ObservedObject var iapManager: IAPManager = IAPManager()

    @State private var offset = CGSize.zero
    @State var showLeader = false
    @State var gameOver = false
    
    @State var playerName: String
    
    init(playerName: String) {
            self._playerName = State(initialValue: playerName)
        }
    
    let desiredScores: [Int] = [200, 500, 900, 1000, 1500, 2000]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeElapsed: Int = 0
    @State private var gameStarted: Bool = false
    @State var boardSize: Int = 3

    var cornerRadius: CGFloat = 10

    var body: some View {
        ZStack {
            Group {
                if splashActive {
                    LoadingScreen()
                } else {
                    NavigationView {
                        ZStack {
                            Image("BG")
                                .resizable()
                                .ignoresSafeArea(.all)
                            
                            // MARK: - Screen Content
                            VStack {

                                // MARK: - Timer
                                if gameStarted {
                                    Text("Timer: \(timeElapsed) seconds")
                                        .onReceive(timer) { _ in
                                            if gameStarted {
                                                timeElapsed += 1
                                            }
                                            
                                        }
                                        //.bold()
                                        .font(.system(size: 10, design: .serif))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white)
                                                .shadow(color: .darkGray, radius: 10, x: 0, y: 5)
                                                .padding([.leading, .trailing], -10)
                                        )
                                        .padding()
                                }
                                
                                // MARK: - SCORE
                                HStack {
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text(NSLocalizedString("SCORE", comment: ""))
                                            .fontWeight(.bold)
                                            .font(.system(size: 10, design: .serif))
                                            .foregroundColor(.darkGray)
                                        Text(String(game.score))
                                            .fontWeight(.bold)
                                            .foregroundColor(.darkGray)
                                    }
                                    .modifier(IsoRoundedBorder(Color.backgroundGray))
                                    
                                    VStack {
                                        Text(NSLocalizedString("BEST", comment: ""))
                                            .fontWeight(.bold)
                                            .font(.system(size: 10, design: .serif))
                                            .foregroundColor(.darkGray)
                                        Text(String(game.highest))
                                            .foregroundColor(Color.darkGray)
                                            .fontWeight(.bold)
                                    }
                                    .modifier(IsoRoundedBorder(Color.shadowGray))
                                    
                                }.padding()
                                
                                
                                // MARK: - Board
                                VStack {
                                    ForEach(game.board.grid, id: \.self) { line in
                                        HStack {
                                            ForEach(line, id: \.self) { tile in
                                                TileView(tile: tile)
                                            }
                                        }
                                    }
                                }
                                .modifier(IsoRoundedBorder(Color.backgroundGray))
                                .padding()
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            self.offset = gesture.translation
                                        }
                                        .onEnded { value in
                                            if value.translation.width < 0
                                                && value.translation.height > -100
                                                && value.translation.height < 100 {
                                                self.game.move(direction: .left)
                                            } else if value.translation.width > 0
                                                        && value.translation.height > -100
                                                        && value.translation.height < 100 {
                                                self.game.move(direction: .right)
                                            } else if value.translation.height < 0
                                                        && value.translation.width < 100
                                                        && value.translation.width > -100 {
                                                self.game.move(direction: .up)
                                            } else if value.translation.height > 0
                                                        && value.translation.width < 100
                                                        && value.translation.width > -100 {
                                                self.game.move(direction: .down)
                                            }
                                        }
                                )
                                
                                // MARK: - Control buttons
                                HStack(alignment: .bottom) {
                                    NavigationLink(
                                        destination: OptionsScreen(username: $playerName,
                                                                   boardSize: $boardSize,
                                                                   game: game, iapManager: iapManager),
                                        label: { Text(NSLocalizedString("Options",
                                                                        comment: "")).foregroundColor(.darkGray).font(.system(size: 14, design: .serif)) })
                                    .modifier(IsoRoundedBorder(Color.backgroundGray))
                                    
                                    NavigationLink(
                                        destination: LeaderBoard(game: game),
                                        label: { Text(NSLocalizedString("Leaderboard",
                                                                        comment: "")).foregroundColor(.darkGray).font(.system(size: 14, design: .serif)) })
                                    .modifier(IsoRoundedBorder(Color.backgroundGray))
                                }.padding()
                            }
                        }
                        .sheet(isPresented: $showLeader) { LeaderBoard(game: game) }
                        .alert(isPresented: $gameOver) {
                            Alert(title: Text(NSLocalizedString("GameOver", comment: "")),
                                  message: Text(NSLocalizedString("No Moves Available.", comment: "")),
                                  dismissButton: .default(Text(NSLocalizedString("OK", comment: "")), action: {
                                if game.state == .won {
                                    self.showLeader.toggle()
                                }
                                self.game.state = .start
                                self.timeElapsed = 0
                            }))
                            
                        }
                        .onReceive(game.$state) { state in
                            if [.won, .over].contains(state) {
                                self.gameOver = true
                                //self.timeElapsed = 0
                            }
                        }
                        
                        //.navigationBarTitle(NSLocalizedString("2048", comment: ""), displayMode: .inline)
                        .navigationBarItems(trailing:
                                    Button(NSLocalizedString("Reset", comment: "")) {
                                        game.state = .start
                                        timeElapsed = 0
                                        gameStarted = false
                                        showStartButton = true
                                    }
                                )
                    }
                }
            }
            
            if showStartButton {
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                                .blur(radius: 5)
                                .edgesIgnoringSafeArea(.all)
                            Button(action: {
                                gameStarted = true
                                showStartButton = false
                            }) {
                                Text("Start the Game")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
            
            if showPopup {
                            PopUpView(score: game.score)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showPopup = false
                                    }
                                }
                        }
        }
        
        .onAppear {

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {

                withAnimation {
                    self.splashActive = false
                    self.showStartButton = true
                }
            }
            
        }
        .onReceive(game.$score) { score in
                    if desiredScores.contains(score) {
                        showPopup = true
                    }
                }
        .navigationBarBackButtonHidden(true)
        
    }
        
}
