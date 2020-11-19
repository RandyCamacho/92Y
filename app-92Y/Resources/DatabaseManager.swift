//
//  DatabaseManager.swift
//  app-92Y
//
//  Created by Randy Camacho on 11/16/20.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
}
// MARK: - Account Management
extension DatabaseManager {
    
    public func userEmailExists(with email: String, completion: @escaping ((Bool) -> Void)){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }            
            completion(true)
        })
    }
    
    /// Insert new user to database
    public func insertUser(with user: appUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstname,
            "last_name": user.lastname
        ])
    }
}

struct appUser {
    let firstname: String
    let lastname: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
