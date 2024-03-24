//
//  PropertyEditorBase.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/8/24.
//

import SwiftUI

/// The default frame for all fields.
struct DefaultFrame<T: View>: View, EditorFrame {
    var label: String = ""
    @ViewBuilder let view: () -> T
    
    var body: some View {
        HStack {
            Text(String(localized: "\(label)"))
                .bold()
            Divider()
            view()
        }
    }
}

#Preview {
    @State var testWord = Word(
        key: "testWord",
        notes: "hrchrch",
        pronounce: "mkntxuuntxmn"
    )
    
    return List {
        DefaultFrame(label: "Default") {
            TextValueField(value: $testWord.notes, prompt: "testNotes")
        }
        
        DefaultFrame(label: "Proficiency") {
            SelectionValueField(value: $testWord.proficiency)
        }
    }
}
