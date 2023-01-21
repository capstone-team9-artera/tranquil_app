//
//  JournalView.swift
//  Anxiety_App
//
//  Created by Heather Dinh on 11/20/22.
//


import SwiftUI

struct JournalView: View {
    @Environment(\.dismiss) var dismiss

    @State var entry = ""
    var body: some View {
        VStack {
            Text("Journal Entry 12/5")
            TextField("Entry", text: $entry, axis: .vertical)

                        .textFieldStyle(.roundedBorder)
                        .padding()
            Button("Dismiss me") {
                dismiss()
            }

        }
        .padding()
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
