//
//  UserRr.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import SwiftUI

struct RegisterView: View {
    @State var registeredName = ""
    @State var registeredSuccessfully = false
    @State private var pulsate: Bool = false

    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .ignoresSafeArea(.all)

            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()  // To allow the image to resize
                    .scaledToFit()  // To maintain the aspect ratio
                    .frame(width: 300, height: 250)  // Change this to suit your needs
                    .shadow(color: .gray, radius: 10)

                //Spacer()
                
                Text("Let's add your player name!")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(color: .lightGray, radius: 10, x: 0, y: 5)
                            .padding([.leading, .trailing], -10)
                    )
                    .multilineTextAlignment(.center)
                    
                    .shadow(color: .lightGray, radius: 5)
                    .padding()

                TextField("Enter your name", text: $registeredName)
                    .frame(width: 200, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(color: .shadowGray, radius: 10, x: 0, y: 5)
                            .padding([.leading, .trailing], -10)
                    )
                    .padding()

                Button(action: {
                    registeredSuccessfully = true
                    GameEngine.shared.playerName = registeredName
                }) {
                    Text("Play a game")
                        .font(.system(size: 30, design: .serif))
                        //.bold(true)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.shadowGray)
                                .shadow(color: .white, radius: 10, x: 0, y: 5)
                                .padding([.leading, .trailing], -10)
                        )
                        .opacity(self.pulsate ? 1.2 : 1)
                        .scaleEffect(self.pulsate ? 1.3 : 1, anchor: .center)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsate)
                        //.cornerRadius(10)
                        .onAppear() {
                            self.pulsate.toggle()
                        }
                }

                Spacer()

                NavigationLink(destination: MainScreen(playerName: registeredName), isActive: $registeredSuccessfully) {
                    EmptyView()
                }
                .buttonStyle(PlainButtonStyle())
                .shadow(color: Color("pink"), radius: 7)
                .navigationBarBackButtonHidden(true)
                
                Spacer()
            }

            // Add your logo image here.
//            Image("logo")
//                .resizable()  // To allow the image to resize
//                .scaledToFit()  // To maintain the aspect ratio
//                .frame(width: 200, height: 200)  // Change this to suit your needs
//                .shadow(color: .gray, radius: 10)
        }
    }
}
