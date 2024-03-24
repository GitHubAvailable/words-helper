//
//  LongTextProperty.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/6/24.
//

import SwiftUI

/// A section frame for a field.
///
/// Used for displaying long text.
struct SectionFrame<T: View>: View, EditorFrame {
    var label: String = ""
    let view: () -> T
    
    var body: some View {
        Section(String(localized: "\(label)")) {
            view()
        }
    }
}

#Preview {
    @State var testWord = Word(key: "testWord", notes: "hrchrch", detail: "oehmnmnt")
    let label = "testLabel"
    return Form {
        SectionFrame(label: label) {
            LongTextValueField(value: $testWord.detail, prompt: "mnmnt")
        }
    }
}
