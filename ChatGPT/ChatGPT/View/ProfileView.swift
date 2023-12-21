//
//  ProfileView.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI

struct ProfileView: View {
    @State private var key: String=UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                TextField("金鑰序號", text: self.$key) {
                    UserDefaults.standard.set(self.key, forKey: "openai_api_key")
                }
                .padding()
                .background(.ultraThickMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.horizontal)
            }
            .navigationTitle("OpenAI金鑰")
            .toolbarTitleDisplayMode(.large)
        }
    }
}
