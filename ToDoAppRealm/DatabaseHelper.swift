//
//  DatabaseHelper.swift
//  ToDoAppRealm
//
//  Created by Yogesh Patel on 15/02/22.
//

import RealmSwift
import UIKit

class DatabaseHelper{
    
    static let shared = DatabaseHelper()
    /// Open the local-only default realm
    private var realm = try! Realm()
    
    func getDatabasePath() -> URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    func saveContact(contact: Contact){
        try! realm.write({
            realm.add(contact)
        })
    }
    
    func updateContact(oldContact: Contact, newContact: Contact){
        try! realm.write{
            //Yogesh = Pratik(BOSS)
            oldContact.firstname = newContact.firstname
            oldContact.lastname = newContact.lastname
        }
    }
    
    func deleteContact(contact: Contact){
        try! realm.write{
            realm.delete(contact)
        }
    }
    
    func getAllContacts() -> [Contact]{
        return Array(realm.objects(Contact.self))
    }
    
}
