//
//  NumberOverlay.swift
//  Kofy
//
//  Created by Diego Gutierrez on 28/10/23.
//

// Obtained from: https://ondrej-kvasnovsky.medium.com/how-display-a-notification-count-badge-in-swiftui-f4fd243f557

import SwiftUI

struct NumberOverlay : View {
  @Binding var value: Int
  @State var foreground: Color = .white
  @State var background: Color = .red
  
  private let size = 20.0
  
  var body: some View {
    ZStack {
      Capsule()
        .fill(background)
        .frame(width: size * widthMultplier(), height: size, alignment: .topTrailing)
      
      if hasTwoOrLessDigits() {
        Text("\(value)")
          .foregroundColor(foreground)
          .font(Font.caption)
      } else {
        Text("99+")
          .foregroundColor(foreground)
          .font(Font.caption)
          .frame(width: size * widthMultplier(), height: size, alignment: .topTrailing)
      }
    }
  }
  
  // showing more than 99 might take too much space, rather display something like 99+
  func hasTwoOrLessDigits() -> Bool {
    return value < 100
  }
  
  func widthMultplier() -> Double {
    if value < 10 {
      // one digit
      return 1.0
    } else if value < 100 {
      // two digits
      return 1.5
    } else {
      // too many digits, showing 99+
      return 2.0
    }
  }
}


#Preview {
    NumberOverlay(value: .constant(1))
}
