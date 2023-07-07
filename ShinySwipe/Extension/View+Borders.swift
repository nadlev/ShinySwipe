//
//  View+Borders.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import SwiftUI

struct ViewBorders: View {
    var body: some View {
        Text("Hello World")
            .modifier(IsoRoundedBorder(Color.backgroundGray))
    }
}

struct IsoRoundedBorder<S>: ViewModifier where S: ShapeStyle {
    let shapeStyle: S
    var width: CGFloat = 1
    let cornerRadius: CGFloat

    init(_ shapeStyle: S) {
        self.shapeStyle = shapeStyle
        self.width = 1
        self.cornerRadius = 15
    }

    func body(content: Content) -> some View {
        return content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(LinearGradient.diagonalDarkBorder, lineWidth: width)
            )
            .background(Color.backgroundGray)
            .cornerRadius(cornerRadius)
            .shadow(
              color: Color(white: 1.0).opacity(0.9),
              radius: 7,
              x: -7,
              y: -7)
            .shadow(
              color: Color.shadowGray.opacity(0.5),
              radius: 5,
              x: 5,
              y: 5)
    }
}

struct IsoRoundedBorders<S>: ViewModifier where S: ShapeStyle {
    let shapeStyle: S
    var width: CGFloat = 1
    let cornerRadius: CGFloat

    init(_ shapeStyle: S) {
        self.shapeStyle = shapeStyle
        self.width = 1
        self.cornerRadius = 15
    }

    func body(content: Content) -> some View {
        return content
            .padding()
            //.background(Color.backgroundGray)
            //.cornerRadius(cornerRadius)
            .shadow(
              color: Color(white: 1.0).opacity(0.9),
              radius: 7,
              x: -7,
              y: -7)
            .shadow(
              color: Color.shadowGray.opacity(0.5),
              radius: 5,
              x: 5,
              y: 5)
    }
}

struct ViewBorders_Previews: PreviewProvider {
    static var previews: some View {
        ViewBorders()
    }
}
