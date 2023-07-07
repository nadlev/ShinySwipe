//
//  LeaderBoard.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//


import SwiftUI

struct LeaderBoard: View {
    @ObservedObject var game: GameEngine

    var body: some View {
        ZStack {
            Color.shadowGray.edgesIgnoringSafeArea(.all)

            VStack {
                Text(NSLocalizedString("🌟LEADERBOARD🌟", comment: ""))
                    //.font(.largeTitle)
                    .font(.system(size: 30, design: .serif))

                List {
                    ForEach(game.leaderBoard, id: \.self) {
                        BoardItem(record: $0)
                                .modifier(IsoRoundedBorder(Color("pink")))
                    }
                    .onDelete(perform: deleteRecord)
                    .listRowBackground(Color.backgroundGray)
                }
            }
        }
    }

    func deleteRecord(at offsets: IndexSet) {
        game.leaderBoard.remove(atOffsets: offsets)
    }
}

struct BoardItem: View {
    var record: Record

    var body: some View {
        ZStack {
            HStack {
                Text(record.playerName)
                    .font(.system(size: 17, design: .serif))
                Spacer()
                Text("\(record.score)💫")
                    .font(.system(size: 17, design: .serif))
                
            }
        }
    }
}

struct LeaderBoard_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameEngine()
        let record = Record(playerName: "Tarrask", score: 123123)
        for _ in 1...20 {
            game.leaderBoard.append(record)
        }
        return LeaderBoard(game: game)
    }
}
