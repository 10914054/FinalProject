//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI

@main
struct ChatGPTApp: App {
    @ObservedObject var state: AppState=AppState()
    
    var body: some Scene {
        WindowGroup {
            if(self.state.logIn) {
                NavigationStack(path: self.$state.path) {
                    ChatsView()
                        .environmentObject(self.state)
                        .preferredColorScheme(.dark)
                }
            } else {
                AuthenticationView()
                    .environmentObject(self.state)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
