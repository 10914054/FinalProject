//
//  ChatView.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI

struct ChatView: View {
    @StateObject var chat: ChatViewModel
    
    @ViewBuilder
    private func MessageView(for message: AppMessage) -> some View {
        HStack {
            if(message.role == .user) {
                Spacer()
            }
            
            Text(message.text)
                .foregroundStyle(message.role == .user ? .white:.black)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(message.role == .user ? .gray:.white)
                .clipShape(.rect(cornerRadius: 10, style: .continuous))
            
            if(message.role == .assistant) {
                Spacer()
            }
        }
    }
    
    private func scrollToBottom(scroll: ScrollViewProxy) {
        guard !self.chat.message.isEmpty, let last=self.chat.message.last else { return }
        withAnimation(.smooth) {
            scroll.scrollTo(last.id)
        }
    }
    private func send() {
        Task {
            do {
                try await self.chat.sendMessage()
            } catch {
                print("ChatView Error: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            self.chatSelection
            ScrollViewReader {scroll in
                List(self.chat.message) {message in
                    self.MessageView(for: message)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .id(message.id)
                        .onChange(of: self.chat.message) {
                            self.scrollToBottom(scroll: scroll)
                        }
                }
                .background(Color(.systemGray3))
                .listStyle(.plain)
            }
            
            self.inputView
        }
        .navigationTitle(self.chat.chat?.topic ?? "新聊天室")
        .toolbarTitleDisplayMode(.inline)
        .onAppear {
            self.chat.fetchData()
        }
    }
    var chatSelection: some View {
        Group {
            if let model=self.chat.chat?.model?.rawValue {
                Text(model)
            } else {
                Picker("", selection: self.$chat.model) {
                    ForEach(ChatType.allCases, id: \.self) {model in
                        Text(model.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
            }
        }
    }
    var inputView: some View {
        HStack {
            TextField("說點什麼...", text: self.$chat.text)
                .padding()
                .background(.ultraThickMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .onSubmit {
                    self.send()
                }
            
            Button {
                self.send()
            } label: {
                Text("發送")
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .background(.ultraThickMaterial)
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
        .padding()
    }
}

#Preview {
    ChatView(chat: ChatViewModel(id: ""))
}
