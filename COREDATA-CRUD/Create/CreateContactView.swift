//
//  CreateContactView.swift
//  COREDATA-CRUD
//
//  Created by Luiz Araujo on 09/01/23.
//

import SwiftUI

struct CreateContactView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: EditContactViewModel
    @State private var hasError: Bool = false
    
    var body: some View {
        List {
            Section("General") {
                TextField("Name", text: $vm.contact.name)
                    .keyboardType(.namePhonePad)
                
                TextField("Email", text: $vm.contact.email)
                    .keyboardType(.emailAddress)
                
                TextField("Phone Number", text: $vm.contact.phoneNumber)
                    .keyboardType(.phonePad)
                
                
                DatePicker("Birthday",
                           selection: $vm.contact.dob,
                           displayedComponents: [.date])
                .datePickerStyle(.compact)
                
            }
            
            Section("Notes") {
                TextField("",
                          text: $vm.contact.notes,
                          axis: .vertical)
            }
        }
        .navigationTitle(vm.isNew ? "New Contact" : "Update Contact")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    validate()
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("cancel") {
                    dismiss()
                }
            }
        }
        .alert("Something aint right",
        isPresented: $hasError,
               actions: { }) {
            Text("It looks like your form is invalid!")
        }
    }
}

private extension CreateContactView {
    func validate() {
        if vm.contact.isValid {
            hasError = false
            
            do {
                try vm.save()
                dismiss()
            } catch {
                //TODO: ☑️ FAZER DEPOIS
            }
        } else {
            hasError = true
        }
    }
}

struct CreateContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let preview = ContactsProvider.shared
            
            CreateContactView(vm: .init(provider: preview))
                .environment(\.managedObjectContext, preview.viewContext)
        }
    }
}
