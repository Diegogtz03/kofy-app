//
//  Toast.swift
//  Kofy
//
//  Created by Diego Gutierrez on 29/11/23.
//
// Obtained from: https://ondrej-kvasnovsky.medium.com/how-to-build-a-simple-toast-message-view-in-swiftui-b2e982340bd


import Foundation
import SwiftUI

struct Toast: Equatable {
    var style: ToastStyle
    var appearPosition: ToastPosition
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
    var topOffset: CGFloat = -32
}

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

enum ToastPosition {
    case top, bottom
}

extension ToastStyle {
  var themeColor: Color {
      switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
      }
  }
  
  var iconFileName: String {
    switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
    }
  }
}


struct ToastView: View {
  var style: ToastStyle
  var position: ToastPosition
  var message: String
  var width = CGFloat.infinity
  var onCancelTapped: (() -> Void)
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      Image(systemName: style.iconFileName)
        .foregroundColor(style.themeColor)
      Text(message)
        .font(Font.system(.title3))
        .foregroundColor(.white)
      
      Spacer(minLength: 10)
      
      Button {
        onCancelTapped()
      } label: {
        Image(systemName: "xmark")
          .foregroundColor(style.themeColor)
      }
    }
    .padding()
    .frame(minWidth: 0, maxWidth: width)
    .background(.black)
    .cornerRadius(8)
    .overlay(
        RoundedRectangle(cornerRadius: 8)
            .inset(by: 2)
            .stroke(style.themeColor, lineWidth: 2)
            .opacity(0.6)
    )
//    .shadow(color: style.themeColor, radius: 3)
    .padding(.horizontal, 16)
  }
}

struct ToastModifier: ViewModifier {
  @Binding var toast: Toast?
  @State private var workItem: DispatchWorkItem?
  
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          mainToastView()
            .offset(y: toast?.appearPosition == .top ? toast!.topOffset : 0)
            .transition(.move(edge: toast?.appearPosition == .top ? .top : .bottom))
        }.animation(.spring(), value: toast)
      )
      .onChange(of: toast) { oldValue, newValue in
        showToast()
      }
  }
  
  @ViewBuilder func mainToastView() -> some View {
    if let toast = toast {
      VStack {
          if (toast.appearPosition == .bottom) {
              Spacer()
          }
            ToastView(
              style: toast.style,
              position: toast.appearPosition,
              message: toast.message,
              width: toast.width
            ) {
              dismissToast()
            }
          if (toast.appearPosition == .top) {
              Spacer()
          }
      }
    }
  }
  
  private func showToast() {
    guard let toast = toast else { return }
    
    UIImpactFeedbackGenerator(style: .light)
      .impactOccurred()
    
    if toast.duration > 0 {
      workItem?.cancel()
      
      let task = DispatchWorkItem {
        dismissToast()
      }
      
      workItem = task
      DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
  }
  
  private func dismissToast() {
    withAnimation {
      toast = nil
    }
    
    workItem?.cancel()
    workItem = nil
  }
}

extension View {

  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
