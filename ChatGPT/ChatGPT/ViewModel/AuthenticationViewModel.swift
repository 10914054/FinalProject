//
//  AuthenticationViewModel.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var email: String=""
    @Published var password: String=""
    @Published var loading: Bool=false
    @Published var visible: Bool=false
    @Published var exist: Bool=false
    
    let service: AuthenticationService=AuthenticationService()
    
    func authenticate(state: AppState) {
        self.loading=true
        Task {
            do {
                if(self.visible) {
                    let result=try await self.service.logIn(email: self.email, password: self.password, exist: self.exist)
                    await MainActor.run {
                        guard let result=result else { return }
                        state.current=result.user
                    }
                } else {
                    self.exist=try await self.service.userExist(email: self.email)
                    self.visible=true
                }
                self.loading=false
            } catch {
                print("AuthenticationViewModel Error: \(error)")
                await MainActor.run {
                    self.loading=false
                }
            }
        }
    }
}
