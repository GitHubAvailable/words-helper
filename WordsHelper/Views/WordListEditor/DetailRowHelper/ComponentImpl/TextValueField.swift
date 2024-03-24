//
//  TextProperty.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/6/24.
//

import SwiftUI

/// A text field used to display short, single-line texts.
struct TextValueField: View, StringField {
    @Binding var value: String
    var prompt: String
    
    var body: some View {
        TextField("value", text: $value, prompt: Text(String(localized: "\(prompt)")))
    }
}

#Preview {
    @State var testWord = Word(key: "testWord", notes: "hrchrch")
    return List {
        TextValueField(value: $testWord.notes, prompt: "testPrompt")
    }
}
