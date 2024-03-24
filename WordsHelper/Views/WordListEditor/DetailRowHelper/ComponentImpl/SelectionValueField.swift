//
//  SelectionProperty.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/8/24.
//

import SwiftUI

/// A single-choice field used to edit enum type values.
struct SelectionValueField<T: IterPickable, S: PickerStyle>: View, ValueField {
    @Binding var value: T
    var style: S
    
    /// Creates a `SelectionValueField` with inital value in
    /// specified style.
    init(
        value: Binding<T>,
        style: S = DefaultPickerStyle.automatic
    ) {
        _value = value
        self.style = style
    }
    
    var body: some View {
        Picker("", selection: $value) {
            ForEach(T.allCases, id: \.id) { t in
                Text(String(describing: t.description)).tag(t)
            }
        }
        .pickerStyle(style)
    }
}

#Preview {
    @State var testWord = Word(key: "testWord", notes: "hrchrch", detail: "oehmnmnt", proficiency: .level3)
    return Form {
        SelectionValueField(value: $testWord.proficiency)
    }
}
