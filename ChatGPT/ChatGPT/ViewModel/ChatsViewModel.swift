//
//  ChatsViewModel.swift
//  ChatGPT
//
//  Created by 曾品瑞 on 2023/12/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatsViewModel: ObservableObject {
    @Published var chat: [AppChat]=[]
    @Published var loading: ChatState = .none
    @Published var show: Bool=false
    
    private let database: Firestore=Firestore.firestore()
    
    func createChat(user: String?) async throws -> String {
        let document: DocumentReference=try await self.database
            .collection("Chat")
            .addDocument(data: ["lastSent": Date(), "Owner": user ?? ""])
        return document.documentID
    }
    func deleteChat(chat: AppChat) {
        guard let id=chat.id else { return }
        self.database.collection("Chat").document(id).delete()
    }
    func fetchData(user: String?) {
        if(self.loading == .none) {
            self.loading = .loading
            self.database
                .collection("Chat")
                .whereField("Owner", isEqualTo: user ?? "")
                .addSnapshotListener {[weak self] (query, error) in
                    guard let self=self, let document=query?.documents, !document.isEmpty else {
                        self?.loading = .noResult
                        return
                    }
                    
                    self.chat=document.compactMap {snapshot -> AppChat? in
                        return try? snapshot.data(as: AppChat.self)
                    }
                    .sorted(by: { $0.lastSent>$1.lastSent })
                    self.loading = .resultFound
                }
        }
    }
    func showProfile() {
        self.show=true
    }
}
