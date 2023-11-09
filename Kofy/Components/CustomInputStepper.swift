//
//  CustomInputStepper.swift
//  Kofy
//
//  Created by Diego Gutierrez on 28/10/23.
//

import SwiftUI

struct CustomInputStepper: View {
    @Binding var value: Int
    var lowerRange: Int
    var upperRange: Int
    
    @State var increaseDisabled = false
    @State var decreaseDisabled = false
    
    func increaseValue() {
        if (value + 1 <= upperRange) {
            value += 1
            
            if (value == upperRange) {
                increaseDisabled = true
            }
            
            if (decreaseDisabled) {
                decreaseDisabled = false
            }
        } else if (!increaseDisabled) {
            increaseDisabled = true
            decreaseDisabled = false
        }
    }
    
    func decreaseValue() {
        if (value - 1 >= lowerRange) {
            value -= 1
            
            if (value == lowerRange) {
                decreaseDisabled = true
            }
            
            if (increaseDisabled) {
                increaseDisabled = false
            }
        } else if (!decreaseDisabled) {
            increaseDisabled = false
            decreaseDisabled = true
        }
    }
    
    var body: some View {
        ZStack {
            Color(.white)
            HStack(spacing: 14) {
                Button {
                    decreaseValue()
                } label: {
                    Image(systemName: "minus")
                }
                .foregroundStyle(decreaseDisabled ? .gray : .black)
                .disabled(decreaseDisabled)
                .buttonRepeatBehavior(.enabled)
                
                Text("\(value) cm")
                    .font(Font.system(size: 17))
                    .frame(width: 60)
                
                Button {
                    increaseValue()
                } label: {
                    Image(systemName: "plus")
                }
                .foregroundStyle(increaseDisabled ? .gray : .black)
                .disabled(increaseDisabled)
                .buttonRepeatBehavior(.enabled)
            }
            
        }
        .frame(width: 150, height: 35)
        .bold()
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
    }
}

#Preview {
    @State var height = 120
    
    return
        ZStack {
            Color(.white)
            CustomInputStepper(value: $height, lowerRange: 0, upperRange: 5)
        }
}
