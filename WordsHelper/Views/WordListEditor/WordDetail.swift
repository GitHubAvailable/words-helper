//
//  WordDetail.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/6/24.
//

import SwiftUI

/// All fields within the view `ListInfoEditor`.
fileprivate enum FieldName: Int, Hashable {
    case key = 1
    case notes
    case pronounce
    case proficiency
    case detail
}

/** hardcoded, since cannot set value synchronously through reflection
 */
// TODO: Try to create and manage rows by iteration
/// A view for one to edit attribute of a `Word` object.
struct WordDetail: View {
    typealias Factory = PropertyDisplayFactory
    
    /// The `Word` being edited.
    @EnvironmentObject var word: Word
    
    /// The `UndoManager` that stores all changes.
    @EnvironmentObject var undoManager: UndoManager
    
    /// The current field being edited.
    @FocusState private var focusedField: FieldName?
    
    /// The current value of the field being edited.
    @State private var oldValue: Any = ""
    
    var body: some View {
        List {
            Section {
                Factory.getFrame("言") {
                    Factory.getStringField(
                        $word.key,
                        prompt: String(localized: "欲志之項也")
                    )
                    .focused($focusedField, equals: .key)
                    .onChange(of: word.key) { [old = word.key] new in
                        changeValue("key", old)
                    }
                    .onSubmit {
                        toNext()
                    }
                }
                
                Factory.getFrame("義") {
                    Factory.getStringField( $word.notes,
                        prompt: String(localized: "簡注焉")
                    )
                    .focused($focusedField, equals: .notes)
                    .onChange(of: word.notes) { [old = word.key] new in
                        changeValue("notes", old)
                    }
                    .onSubmit {
                        toNext()
                    }
                }
                
                Factory.getFrame("音") {
                    Factory.getStringField( $word.pronounce,
                        prompt: String(localized: "言之声也")
                    )
                    .focused($focusedField, equals: .pronounce)
                    .onChange(of: word.pronounce) { [old = word.pronounce] new in
                        changeValue("pronounce", old)
                    }
                    .onSubmit {
                        toNext()
                    }
                }
                
                Factory.getFrame("熟") {
                    Factory.getSelectionField( $word.proficiency
                    )
                    .focused($focusedField, equals: .proficiency)
                    .onChange(of: word.proficiency) { [old = word.proficiency] new in
                        changeValue("proficiency", old)
                    }
                    .onSubmit {
                        toNext()
                    }
                }
            }
            
            Factory.getFrame(type: .section, "述") {
                Factory.getStringField(
                    type: .longText,
                    $word.detail,
                    prompt: "詳解焉"
                )
                .focused($focusedField, equals: .detail)
                .onChange(of: word.detail) { [old = word.detail] new in
                    changeValue("detail", old)
                }
                .onSubmit {
                    toNext()
                }
            }
            // prompt not shown under current style
        }
        .listStyle(.inset)
    }
    
    /// Record undo action for a value change of a specific attribute.
    private func changeValue<T>(_ key: String, _ old: T) {
        undoManager.registerUndo(withTarget: word) { w in
            w.setValue(old, forKey: key)
        }
    }
    
    /// Move the cursor to next field.
    private func toNext() {
        switch focusedField {
        case .detail:
            focusedField = nil
        case nil:
            break
        default:
            focusedField = FieldName(rawValue: focusedField!.rawValue + 1)
        }
    }
}

#Preview {
    @State var word = Word(
        key: "testWord",
        notes: "notes",
        detail: "describe",
        pronounce: "[OOeeqqq]",
        proficiency: .init(rawValue: 3)!
    )
    return WordDetail()
        .environmentObject(word)
        .environmentObject(UndoManager())
}
