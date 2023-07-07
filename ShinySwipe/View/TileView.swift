//
//  TileView.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import SwiftUI

struct TileView: View {
    var cornerRadius: CGFloat = 10

    var tile: Tile

    var bgcolor: Color {
        switch tile.value {
        case 2:
            return Color("tile2")
        case 4:
            return Color("tile4")
        case 8:
            return Color("tile8")
        case 16:
            return Color("tile16")
        case 32:
            return Color("tile32")
        case 64:
            return Color("tile64")
        case 128:
            return Color("tile128")
        case 256:
            return Color(UIColor(red: 0.94, green: 0.82, blue: 0.34, alpha: 1.00))
        case 512:
            return Color(UIColor(red: 0.94, green: 0.80, blue: 0.25, alpha: 1.00))
        case 1024:
            return Color(UIColor(red: 0.94, green: 0.78, blue: 0.16, alpha: 1.00))
        case 2048:
            return Color(UIColor(red: 0.94, green: 0.78, blue: 0.00, alpha: 1.00))
        default:
            return Color.specialGray
        }
    }

    var body: some View {
            GeometryReader { geometry in
                ZStack {
                                Rectangle()
                                    //.foregroundColor(bgcolor).opacity(0.6)
                                    .cornerRadius(cornerRadius)
                                    .border(Color.gray, width: 1)
                                
                    if tile.value > 0 {
                                        Image("tile_\(tile.value)")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .shadow(color: Color.white, radius: 30)
                                        
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(String("x\(tile.value)"))
                                                    .fontWeight(.black)
                                                    .font(.system(size: geometry.size.height > geometry.size.width ?
                                                        geometry.size.width * 0.13: geometry.size.height * 0.2))
                                                    .foregroundColor(.darkGray)
                                                    .modifier(IsoRoundedBorders(Color("pink")))
                                                    //.bold()
                                                Spacer()
                                            }
                                        }
                                        .padding(.bottom, 5)
                                        .padding(.leading, 2)
                                } else {
                                    // Assuming "tile0" is the name of your image for when tile.value == 0
                                    Image("tile0")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .shadow(color: Color.white, radius: 30)
                                }
                            }
                            .padding(tile.value > 0 ? 10 : 0)
                }.animation(.spring())
                .overlay(
                  RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(LinearGradient.diagonalDarkBorder, lineWidth: 2)
                )
                .background(Color.backgroundGray)
                .cornerRadius(cornerRadius)
                .shadow(
                  color: Color(white: 1.0).opacity(0.9),
                  radius: 4,
                  x: -4,
                  y: -4)
                .shadow(
                  color: Color.shadowGray.opacity(0.5),
                  radius: 2,
                  x: 2,
                  y: 2)
            }
        }
    

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        let tile = Tile(value: 0)
        return TileView(tile: tile)
    }
}
