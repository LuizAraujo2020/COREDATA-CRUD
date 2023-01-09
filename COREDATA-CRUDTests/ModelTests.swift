//
//  ModelTests.swift
//  COREDATA-CRUDTests
//
//  Created by Luiz Araujo on 09/01/23.
//

import XCTest
@testable import COREDATA_CRUD

final class ModelTests: XCTestCase {
    
    private var provider: ContactsProvider!
    
    override func setUp() {
        provider = .shared
    }
    
    override func tearDown() {
        provider = nil
    }
    
    func testContactIsEmpty() {
        let contact = Contact.empty(context: provider.viewContext)
        XCTAssertEqual(contact.name, "")
        XCTAssertEqual(contact.phoneNumber, "")
        XCTAssertEqual(contact.email, "")
        XCTAssertFalse(contact.isFavorite, "")
        XCTAssertTrue(Calendar.current.isDateInToday(contact.dob))
    }
    
    func testContactIsNotValid() {
        let contact = Contact.empty(context: provider.viewContext)
        XCTAssertFalse(contact.isValid)
    }
    
    func testContactIsValid() {
        let contact = Contact.preview(context: provider.viewContext)
        XCTAssertTrue(contact.isValid)
    }
    
    func testContactsBirthdayIsValid() {
        let contact = Contact.preview(context: provider.viewContext)
        XCTAssertTrue(contact.isBirthday)
    }
    
    func testContactsBirthdayIsNotValid() throws {
        let contact = try XCTUnwrap(Contact.makePreview(count: 2, in: provider.viewContext).last)
        XCTAssertFalse(contact.isBirthday)
    }
    
    func testMakeContactsPreviewIsValid() {
        let count = 5
        let contacts = Contact.makePreview(count: count, in: provider.viewContext)
        
        
        for i in 0..<contacts.count {
            let item = contacts[i]
            XCTAssertEqual(item.name, "Item \(i)")
            XCTAssertEqual(item.email, "test_\(i)@mail.com")
            XCTAssertNotNil(item.isFavorite)
            XCTAssertEqual(item.phoneNumber, "123241321311")
            
            let dateCompare = Calendar.current.date(byAdding: .day, value: -i, to: .now)
            let dobDay = Calendar.current.dateComponents([.day], from: item.dob, to: dateCompare!).day
            
            XCTAssertEqual(dobDay, 0)
            XCTAssertEqual(item.notes, "This is a preview for item \(i)")
        }
    }
    
    func testFilterFaveContactsRequestIsValid() {
        let request = Contact.filter(with: .init(filter: .fave))
        XCTAssertEqual("isFavorite == 1", request.predicateFormat)
    }
    
    func testFilterAllFaveContactsRequestIsValid() {
        let request = Contact.filter(with: .init(filter: .all))
        XCTAssertEqual("TRUEPREDICATE", request.predicateFormat)
    }
    
    func testFilterAllWithQueryContactsRequestIsValid() {
        let query = "tunds"
        let request = Contact.filter(with: .init(query: query))
        XCTAssertEqual("name CONTAINS[cd] \"\(query)\"", request.predicateFormat)
    }
    
    func testFilterFaveWithQueryContactsRequestIsValid() {
        let query = "tunds"
        let request = Contact.filter(with: .init(filter: .fave, query: query))
        XCTAssertEqual("name CONTAINS[cd] \"\(query)\" AND isFavorite == 1", request.predicateFormat)
    }
}
