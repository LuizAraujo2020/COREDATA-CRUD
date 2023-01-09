//
//  COREDATA_CRUDApp.swift
//  COREDATA-CRUD
//
//  Created by Luiz Araujo on 09/01/23.
//

import SwiftUI

@main
struct COREDATA_CRUDApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
        }
    }
}
