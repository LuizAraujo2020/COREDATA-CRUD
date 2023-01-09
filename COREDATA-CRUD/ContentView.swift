//
//  ContentView.swift
//  COREDATA-CRUD
//
//  Created by Luiz Araujo on 09/01/23.
//

import SwiftUI

struct SearchConfig: Equatable {
    enum Filter {
        case all, fave
    }
    
    var filter = Filter.all
    var query  = ""
}

enum Sort {
    case asc, desc
}

struct ContentView: View {
    @FetchRequest(fetchRequest: Contact.all()) private var contacts
    @State private var contactToEdit: Contact?
    @State private var searchConfig = SearchConfig()
    @State private var sort: Sort = .asc
    
    var provider = ContactsProvider.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                if contacts.isEmpty {
                    NoContactsView()
                } else {
                    List {
                        ForEach(contacts) { contact in
                            /// ZStack to hide the chevron
                            ZStack(alignment: .leading) {
                                NavigationLink(destination: ContactDetailView(contact: contact)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                ContactRowView(contact: contact, provider: provider)
                                    .swipeActions(allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            do {
                                                try provider.delete(contact, in: provider.newContext)
                                            } catch {
                                                print(error)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                        
                                        Button {
                                            contactToEdit = contact
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.orange)
                                    }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchConfig.query)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        contactToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section("Filter") {
                            Picker(selection: $searchConfig.filter) {
                                Text("All").tag(SearchConfig.Filter.all)
                                Text("Favorites").tag(SearchConfig.Filter.fave)
                            } label: {
                                Text("Filter Faves")
                            }

                        }
                        
                        Section("Sort") {
                            Picker(selection: $sort) {
                                Label("Ascending", systemImage: "arrow.up").tag(Sort.asc)
                                Label("Descending", systemImage: "arrow.down").tag(Sort.desc)
                            } label: {
                                Text("Sort By")
                            }

                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                            .font(.title2)
                    }
                }
            }
            .sheet(item: $contactToEdit, onDismiss: {
                contactToEdit = nil
            }, content: { contact in
                NavigationStack {
                    CreateContactView(vm: .init(provider: provider, contact: contact))
                }
            })
            .navigationTitle("Contacts")
            .onChange(of: searchConfig) { newConfig in
                contacts.nsPredicate = Contact.filter(with: newConfig)
            }
            .onChange(of: sort) { newSort in
                contacts.nsSortDescriptors = Contact.sort(order: newSort)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let preview = ContactsProvider.shared
        
        ContentView(provider: preview)
            .previewDisplayName("Contacts with data")
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                Contact.makePreview(count: 10, in: preview.viewContext)
            }
        
        
        let emptyPreview = ContactsProvider.shared
        ContentView(provider: emptyPreview)
            .previewDisplayName("Contacts with no data")
            .environment(\.managedObjectContext, emptyPreview.viewContext)
    }
}
