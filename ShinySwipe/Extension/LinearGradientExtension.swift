//
//  LinearGradientExtension.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import SwiftUI

extension LinearGradient {
  public static var diagonalDarkBorder: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.white, .specialGray]),
      startPoint: UnitPoint(x: -0.2, y: 0.5),
      endPoint: .bottomTrailing
    )
  }

  public static var diagonalLightBorder: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.white, .lightGray]),
      startPoint: UnitPoint(x: 0.2, y: 0.2),
      endPoint: .bottomTrailing
    )
  }

  public static var horizontalDark: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.shadowGray, .darkGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }

  public static var horizontalDarkReverse: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.darkGray, .shadowGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }

  public static var horizontalDarkToLight: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [
        .shadowGray,
        Color.white.opacity(0.0),
        .white]),
      startPoint: .top,
      endPoint: .bottom
    )
  }

  public static var verticalLightToDark: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [
        .white,
        Color.white.opacity(0.0),
        .shadowGray]),
      startPoint: .top,
      endPoint: .bottom
    )
  }

  public static var horizontalLight: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.offWhite, .backgroundGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }
}
