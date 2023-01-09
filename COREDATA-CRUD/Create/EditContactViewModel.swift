//
//  EditContactViewModel.swift
//  COREDATA-CRUD
//
//  Created by Luiz Araujo on 09/01/23.
//

import CoreData

final class EditContactViewModel: ObservableObject {
    @Published var contact: Contact
    let isNew: Bool
    private let provider: ContactsProvider
    private let context: NSManagedObjectContext
    
    init(provider: ContactsProvider, contact: Contact? = nil) {
        self.provider = provider
        self.context = provider.newContext
        if let contact, let existingContactCopy = provider.exists(contact,
                                                                  in: context) {
            isNew = false
            self.contact = existingContactCopy
        } else {
            isNew = true
            self.contact = Contact(context: self.context)
        }
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
}
