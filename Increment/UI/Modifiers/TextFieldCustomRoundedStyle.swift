//
//  TextFieldCustomRoundedStyle.swift
//  Increment
//
//  Created by Tony Mu on 28/08/21.
//

import SwiftUI

struct TextFieldCustomRoundedStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color.primary)
            .padding()
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primary)
            ).padding(.horizontal, 15)
    }
}
