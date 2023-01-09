//
//  ContactRowView.swift
//  COREDATA-CRUD
//
//  Created by Luiz Araujo on 09/01/23.
//

import SwiftUI

struct ContactRowView: View {
    @Environment(\.managedObjectContext) private var mOC
    
    @ObservedObject var contact: Contact
    
    let provider: ContactsProvider
    
    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(contact.formattedName)
                    .font(.system(size: 26, design: .rounded).bold())
                
                Text(contact.email)
                    .font(.callout.bold())
                
                Text(contact.phoneNumber)
                    .font(.callout.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .topTrailing) {
                Button {
                    toggleFave()
                    
                } label: {
                    Image(systemName: "star")
                        .font(.title3)
                        .symbolVariant(contact.isFavorite ? .fill : .none)
                        .foregroundColor(contact.isFavorite ? .yellow : .gray.opacity(0.3))
                }
                .buttonStyle(.plain)
            }
    }
}

private extension ContactRowView {
    func toggleFave() {
        contact.isFavorite.toggle()
        
        do {
            try provider.persist(in: mOC)
            
        } catch {
            print(error)
        }
    }
}

struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        let previewProvider = ContactsProvider.shared
        
        ContactRowView(contact: .preview(context: previewProvider.viewContext), provider: previewProvider)
    }
}
