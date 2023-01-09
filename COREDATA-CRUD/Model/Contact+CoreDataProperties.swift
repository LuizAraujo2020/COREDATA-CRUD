//
//  Contact+CoreDataProperties.swift
//  COREDATA-CRUD
//
//  Created by Luiz Araujo on 09/01/23.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var dob: Date
    @NSManaged public var email: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String
    @NSManaged public var notes: String
    @NSManaged public var phoneNumber: String
}

extension Contact : Identifiable {

}
