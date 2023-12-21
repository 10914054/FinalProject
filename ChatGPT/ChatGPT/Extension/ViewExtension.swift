//
//  ViewExtension.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI

extension View {
    func logInField() -> some View {
        self
            .textInputAutocapitalization(.never)
            .padding()
            .background(.ultraThickMaterial)
            .clipShape(.rect(cornerRadius: 10))
    }
}
