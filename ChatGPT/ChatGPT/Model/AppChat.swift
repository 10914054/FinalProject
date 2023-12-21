//
//  AppChat.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI
import FirebaseFirestore

struct AppChat: Codable, Identifiable {
    @DocumentID var id: String?
    let topic: String?
    var model: ChatType?
    let lastSent: FirestoreDate
    let owner: String
    
    var lastTime: String {
        let now: Date=Date()
        let component: DateComponents=Calendar.current.dateComponents(
            [.second, .minute, .hour, .day, .month, .year],
            from: self.lastSent.date,
            to: now
        )
        let unit: [(value: Int?, unit: String)]=[
            (component.year, "year"),
            (component.month, "month"),
            (component.day, "day"),
            (component.hour, "hour"),
            (component.minute, "minute"),
            (component.second, "second")
        ]
        
        for i in unit {
            if let value=i.value, value>0 {
                return "\(value) \(i.unit)\(value==1 ? "":"s") 之前"
            }
        }
        return "現在"
    }
}
