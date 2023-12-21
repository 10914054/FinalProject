//
//  ChatType.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI
import OpenAI

enum ChatType: String, CaseIterable, Codable, Hashable {
    case gpt35="GPT 3.5 Turbo"
    case gpt4="GPT 4"
    
    var tint: Color {
        switch self {
        case .gpt35:
            return .green
        case .gpt4:
            return .purple
        }
    }
    
    var model: Model {
        switch self {
        case .gpt35:
            return .gpt3_5Turbo
        case .gpt4:
            return .gpt4
        }
    }
}
