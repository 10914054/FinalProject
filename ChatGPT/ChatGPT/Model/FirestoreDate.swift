//
//  FirestoreDate.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/21.
//

import Foundation
import FirebaseFirestore

struct FirestoreDate: Codable, Comparable, Hashable {
    var date: Date
    
    init(date: Date=Date()) {
        self.date = date
    }
    init(from decoder: Decoder) throws {
        let container: SingleValueDecodingContainer=try decoder.singleValueContainer()
        let time: Timestamp=try container.decode(Timestamp.self)
        self.date=time.dateValue()
    }
    
    static func<(lhs: FirestoreDate, rhs: FirestoreDate) -> Bool {
        lhs.date<rhs.date
    }
    
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer=encoder.singleValueContainer()
        let time: Timestamp=Timestamp(date: self.date)
        try container.encode(time)
    }
}
