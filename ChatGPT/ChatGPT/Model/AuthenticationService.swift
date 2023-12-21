//
//  AuthenticationService.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationService {
    let database: Firestore=Firestore.firestore()
    
    func logIn(email: String, password: String, exist: Bool)async throws -> AuthDataResult? {
        guard !password.isEmpty else { return nil }
        if(exist) {
            return try await Auth.auth().signIn(withEmail: email, password: password)
        } else {
            return try await Auth.auth().createUser(withEmail: email, password: password)
        }
    }
    func userExist(email: String) async throws -> Bool {
        let document: AggregateQuery=self.database.collection("User").whereField("email", isEqualTo: email).count
        let count: NSNumber=try await document.getAggregation(source: .server).count
        return Int(truncating: count)>0
    }
}
