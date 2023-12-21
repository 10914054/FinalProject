//
//  ChatViewModel.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI
import OpenAI
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @AppStorage("openai_api_key") private var apiKey=""
    
    @Published var chat: AppChat?
    @Published var message: [AppMessage]=[]
    @Published var text: String=""
    @Published var model: ChatType = .gpt35
    
    let id: String
    let database: Firestore=Firestore.firestore()
    
    init(id: String) {
        self.id = id
    }
    
    func fetchData() {
        self.database
            .collection("Chat")
            .document(self.id)
            .getDocument(as: AppChat.self) {document in
                switch document {
                case .success(let success):
                    DispatchQueue.main.async {
                        self.chat=success
                    }
                case .failure(let failure):
                    print("ChatViewModel: \(failure)")
                }
            }
        
        self.database
            .collection("Chat")
            .document(self.id)
            .collection("Message")
            .getDocuments {(query, error) in
                guard let document=query?.documents, !document.isEmpty else { return }
                self.message=document.compactMap {snapshot -> AppMessage? in
                    do {
                        var message: AppMessage=try snapshot.data(as: AppMessage.self)
                        message.id=snapshot.documentID
                        return message
                    } catch {
                        return nil
                    }
                }
            }
    }
    func sendMessage() async throws {
        var message: AppMessage=AppMessage(id: UUID().uuidString, text: self.text, role: .user)
        
        do {
            let reference: DocumentReference=try self.storeMessage(message: message)
            message.id=reference.documentID
        } catch {
            print("ChatViewModel Error: \(error)")
        }
        
        if(self.message.isEmpty) {
            self.newChat()
        }
        await MainActor.run {[message] in
            self.message.append(message)
            self.text=""
        }
        
        try await self.generateResponse(for: message)
    }
    
    private func generateResponse(for message: AppMessage) async throws {
        let openAI: OpenAI=OpenAI(apiToken: self.apiKey)
        let message: [Chat]=self.message.map {message in
            Chat(role: message.role, content: message.text)
        }
        let query: ChatQuery=ChatQuery(model: self.chat?.model?.model ?? .gpt3_5Turbo, messages: message)
        
        for try await i in openAI.chatsStream(query: query) {
            guard let text=i.choices.first?.delta.content else { continue }
            await MainActor.run {
                if let last=self.message.last, last.role != .user {
                    self.message[self.message.count-1].text+=text
                } else {
                    let new: AppMessage=AppMessage(id: i.id, text: text, role: .assistant)
                    self.message.append(new)
                }
            }
        }
        
        if let last=self.message.last {
            _=try self.storeMessage(message: last)
        }
    }
    private func newChat() {
        self.database.collection("Chat").document(self.id).updateData(["model": self.model.rawValue])
        DispatchQueue.main.async {[weak self] in
            self?.chat?.model=self?.model
        }
    }
    private func storeMessage(message: AppMessage) throws -> DocumentReference {
        return try self.database.collection("Chat").document(self.id).collection("Message").addDocument(from: message)
    }
}
