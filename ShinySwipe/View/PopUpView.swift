//
//  PopUpView.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import SwiftUI

struct PopUpView: View {
    let score: Int
    
    var body: some View {
        VStack {
            Spacer()
            Text("Wow, keep it up!")
                .font(.system(size: 16, design: .serif))
                //.bold(true)
            Spacer()
            Text("You have reached \(score) coins!")
                .multilineTextAlignment(.center)
                .font(.system(size: 18, design: .serif))
                //.bold(true)
            Spacer()
        }
        .frame(width: 200, height: 180)
        .background(Color.shadowGray)
        .cornerRadius(10)
        .shadow(color: Color("pink"), radius: 20)
    }
}
