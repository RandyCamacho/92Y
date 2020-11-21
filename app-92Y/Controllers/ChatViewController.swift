//
//  ChatViewController.swift
//  app-92Y
//
//  Created by Randy Camacho on 11/19/20.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var  sender: SenderType
    var kind: MessageKind
    var messageId: String
    var sentDate: Date
    
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
    var rank: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    
    private let fakeSender = Sender(photoURL: "", senderId: "1", displayName: "Parvizal", rank: "Staff Sergeant")

    override func viewDidLoad() {
        super.viewDidLoad()

        messages.append(Message(sender: fakeSender, kind: .text("Hello World"), messageId: "1", sentDate: Date()))
        
        messages.append(Message(sender: fakeSender, kind: .text("Hello World this is a longer message"), messageId: "1", sentDate: Date()))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return fakeSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
