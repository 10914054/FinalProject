//
//  AppMessage.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import Foundation
import OpenAI
import FirebaseFirestoreSwift

struct AppMessage: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var text: String
    let role: Chat.Role
    let createAt: FirestoreDate=FirestoreDate()
}
