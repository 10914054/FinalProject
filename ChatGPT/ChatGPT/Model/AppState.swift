//
//  AppState.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

class AppState: ObservableObject {
    @Published var current: User?
    @Published var path: NavigationPath=NavigationPath()
    
    var logIn: Bool {
        return self.current != nil
    }
    
    init() {
        FirebaseApp.configure()
        if let current=Auth.auth().currentUser {
            self.current=current
        }
    }
}
