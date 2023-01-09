//
//  ContactDetailView.swift
//  COREDATA-CRUD
//
//  Created by Luiz Araujo on 09/01/23.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    
    var body: some View {
        List {
            Section("General") {
                LabeledContent {
                    Text(contact.email)
                } label: {
                    Text("Email")
                }
                
                LabeledContent {
                    Text("Phone Number Here")
                } label: {
                    Text(contact.phoneNumber)
                }
                
                LabeledContent {
                    Text(.now, style: .date)
                } label: {
                    Text(contact.dob, style: .date)
                }
            }
            
            Section("Notes") {
                Text(contact.notes)
            }
        }
        .navigationTitle(contact.formattedName)
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactDetailView(contact: .preview())
        }
    }
}
