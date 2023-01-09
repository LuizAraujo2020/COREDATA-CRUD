//
//  Contact+CoreDataClass.swift
//  COREDATA-CRUD
//
//  Created by Luiz Araujo on 09/01/23.
//
//

import Foundation
import CoreData


public class Contact: NSManagedObject {
    
    // MARK: Wrappers
    var isBirthday: Bool {
        Calendar.current.isDateInToday(dob)
    }
    
    var formattedName: String {
        "\(isBirthday ? "🥳 " : "")\(name)"
    }
    
    var isValid: Bool {
        !name.isEmpty &&
        !phoneNumber.isEmpty &&
        !email.isEmpty
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date.now, forKey: "dob")
        setPrimitiveValue("", forKey: "email")
        setPrimitiveValue(false, forKey: "isFavorite")
        setPrimitiveValue("", forKey: "name")
        setPrimitiveValue("", forKey: "notes")
        setPrimitiveValue("", forKey: "phoneNumber")
    }
}

// MARK: - Functions
extension Contact {
    static func all() -> NSFetchRequest<Contact> {
        let request: NSFetchRequest<Contact> = fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Contact.name, ascending: true)
        ]
        
        return request
    }
    
    static func filter(with config: SearchConfig) -> NSPredicate {
        switch config.filter {
        case .all:
            return config.query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", config.query)
            
        case .fave:
            return config.query.isEmpty ? NSPredicate(format: "isFavorite == %@", NSNumber(value: true)) : NSPredicate(format: "name CONTAINS[cd] %@ AND isFavorite == %@", config.query, NSNumber(value: true))
        }
    }
    
    static func sort(order: Sort) -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Contact.name, ascending: order == .asc)]
    }
}

// MARK: - Dummies
extension Contact {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Contact] {
        var contacts = [Contact]()
        
        for i in 0..<count {
            let contact = Contact(context: context)
            contact.name = "Item \(i)"
            contact.email = "test_\(i)@mail.com"
            contact.isFavorite = Bool.random()
            contact.phoneNumber = "123241321311"
            contact.dob = Calendar.current.date(byAdding: .day,
                                                 value: -i,
                                                 to: .now) ?? .now
            contact.notes = "This is a preview for item \(i)"
            contacts.append(contact)
        }
        
        return contacts
    }
    
    static func preview(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
        return makePreview(count: 1, in: context)[0]
    }
    
    static func empty(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
        return Contact(context: context)
    }
}
