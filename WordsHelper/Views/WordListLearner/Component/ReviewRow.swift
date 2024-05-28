//
//  ReviewRow.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/20.
//

import SwiftUI

struct ReviewRow: View {
    /// The `Word` to be displayed.
    @ObservedObject var word: Word
    
    /// The `UndoManager` used to save progress.
    @EnvironmentObject private var undoManager: UndoManager
    
    var body: some View {
        HStack {
            Text(word.key)
                .bold()
                .padding(.leading)
                .padding(.trailing, 2)
            Text(word.pronounce)
                .foregroundStyle(.secondary)
            Text(word.notes)
                
            Spacer()
            
            Picker("", selection: $word.proficiency) {
                ForEach(Proficiency.allCases, id: \.id) { t in
                    Text(String(describing: t.description)).tag(t)
                }
            }
            .onChange(of: word.proficiency, perform: { value in
                undoManager.registerUndo(withTarget: word, handler: {word in })
            })
            .pickerStyle(.menu)
        }
    }
}

#Preview {
    @State var word: Word = Word(key: "key", notes: "notes", pronounce: "ebrhr")
    
    return ReviewRow(word: word)
        .environmentObject(UndoManager())
}
