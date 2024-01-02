//
//  AuthenticationView.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var state: AppState
    
    @ObservedObject private var authentication: AuthenticationViewModel=AuthenticationViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ＣＹＵＴ ＩＭ\n線上客服")
                .bold()
                .font(.title)
                .multilineTextAlignment(.center)
            
            TextField("電子郵件", text: self.$authentication.email).logInField()
            
            if(self.authentication.visible) {
                SecureField("密碼", text: self.$authentication.password)
                    .logInField()
                    .transition(.opacity.animation(.smooth))
            }
            
            if(self.authentication.loading) {
                ProgressView()
            } else {
                Button(self.authentication.exist ? "登入":"註冊") {
                    self.authentication.authenticate(state: self.state)
                }
                .padding()
                .foregroundStyle(.white)
                .background(.ultraThickMaterial)
                .clipShape(.rect(cornerRadius: 10))
            }
        }
        .padding()
    }
}
