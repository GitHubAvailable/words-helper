//
//  ListInfoEditor.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/1/24.
//

import SwiftUI

/// All fields within the view `ListInfoEditor`.
fileprivate enum InfoField: Hashable {
    case language
}

/// A view for one to manage certan attributes of `WordsList`.
struct ListInfoEditor: View {
    typealias Factory = PropertyDisplayFactory
    
    // @EnvironmentObject var undoManager: UndoManager
    @Binding var lang: String
    
    /// The current field being edited.
    @FocusState private var focusedField: InfoField?
    
    var body: some View {
        NavigationView {
            Form {
                Factory.getFrame(String(localized: "文")) {
                    Factory.getStringField(
                        $lang,
                        prompt: String(localized: "表之言也")
                    )
                    .focused($focusedField, equals: .language)
                }
            }
            .navigationTitle(String(localized: "表項"))
            .navigationBarTitleDisplayMode(.inline)
            // hides back button as not working
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    @State var lang = "文言"
    
    return ListInfoEditor(lang: $lang)
}
