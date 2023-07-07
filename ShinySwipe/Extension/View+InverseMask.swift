//
//  View+InverseMask.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import SwiftUI

extension View {
  // 1
  func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
    // 2
    self.mask(mask
      // 3
      .foregroundColor(.black)
      // 4
      .background(Color.white)
      // 5
      .compositingGroup()
      // 6
      .luminanceToAlpha()
    )
  }
}
