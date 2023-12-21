//
//  ChatsView.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI
import FirebaseFirestore

struct ChatsView: View {
    @EnvironmentObject private var state: AppState
    
    @StateObject private var chat: ChatsViewModel=ChatsViewModel()
    
    var body: some View {
        Group {
            switch self.chat.loading {
            case .none, .loading:
                Text("載入中...").bold()
            case .noResult:
                Text("沒有聊天室").bold()
            case .resultFound:
                List {
                    ForEach(self.chat.chat) {chat in
                        NavigationLink(value: chat.id) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(chat.topic ?? "新的聊天室").font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(chat.model?.rawValue ?? "")
                                        .bold()
                                        .font(.caption)
                                        .foregroundStyle(chat.model?.tint ?? .white)
                                        .padding(5)
                                        .background((chat.model?.tint ?? .white).opacity(0.2))
                                        .clipShape(.rect(cornerRadius: 5))
                                }
                                
                                Text(chat.lastTime)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .swipeActions {
                            Button("", systemImage: "trash.fill", role: .destructive) {
                                self.chat.deleteChat(chat: chat)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("客服聊天室")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "person.crop.circle") {
                    self.chat.showProfile()
                }
                .tint(.white)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus.bubble") {
                    Task {
                        do {
                            let id: String=try await self.chat.createChat(user: self.state.current?.uid)
                            self.state.path.append(id)
                        } catch {
                            print("ChatsView Error: \(error)")
                        }
                    }
                }
                .tint(.white)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "trash") {
                    let collection=Firestore.firestore().collection("Chat")
                    
                    collection.getDocuments {(snapshot, error) in
                        guard let document=snapshot?.documents else { return }
                        
                        for i in document {
                            let reference=collection.document(i.documentID)
                            reference.delete {_ in }
                        }
                    }
                }
                .tint(.red)
            }
        }
        .sheet(isPresented: self.$chat.show) {
            ProfileView().presentationDetents([.fraction(0.3)])
        }
        .navigationDestination(for: String.self) {id in
            ChatView(chat: ChatViewModel(id: id))
        }
        .onAppear {
            if(self.chat.loading == .none) {
                self.chat.fetchData(user: self.state.current?.uid)
            }
        }
    }
}
