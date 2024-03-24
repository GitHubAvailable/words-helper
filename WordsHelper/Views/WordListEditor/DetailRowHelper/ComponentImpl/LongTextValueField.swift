//
//  LongTextValueEditor.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/9/24.
//

import SwiftUI

/// A text field used to display long paragraphs.
struct LongTextValueField: View, StringField {
    @Binding var value: String
    var prompt: String = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            if value.isEmpty {
                Text(String(localized: "\(prompt)"))
                    .padding(.leading, 7)
                    .padding(.top, -2)
                    .foregroundStyle(.gray)
            }
            TextEditor(text: $value)
        }
    }
}

#Preview {
    @State var testWord = Word(key: "testWord", notes: "hrchrch", detail: "oehmnmnt")
    
    return LongTextValueField(value: $testWord.notes, prompt: "testPrompt")
}
