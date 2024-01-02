//
//  QuickSignInWithApple.swift
//  Kofy
//
//  Created by Diego Gutierrez on 03/12/23.
//

import SwiftUI
import AuthenticationServices

struct QuickSignInWithApple: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    typealias UIViewType = ASAuthorizationAppleIDButton
  
    func makeUIView(context: Context) -> UIViewType {
        return ASAuthorizationAppleIDButton(type: .signIn, style: ASAuthorizationAppleIDButton.Style.white)
    }
  
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
