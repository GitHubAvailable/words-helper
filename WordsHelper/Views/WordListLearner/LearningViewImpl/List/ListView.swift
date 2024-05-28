//
//  ListView.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/17.
//

import SwiftUI

struct ListView: LearningView {
    /// The `UndoManager` used to save progress.
    @EnvironmentObject private var undoManager: UndoManager
    
    var words: [Word]
    
    var body: some View {
        List {
            ForEach(words) { word in
                ReviewRow(word: word)
                    .environmentObject(undoManager)
            }
        }
        .listStyle(.inset)
        Divider()
            .overlay(Color.gray)
        Spacer()
    }
    
    mutating func prev() throws {
        throw BackForthIteratorError
            .indexOutOfRangeException("Move to previous stage")
    }
    
    mutating func next() throws {
        throw BackForthIteratorError
            .indexOutOfRangeException("Move to next stage")
    }
    
    func getProgress() -> String {
        return ""
    }
}

#Preview {
    let words: [Word] = [
        Word(key: "heorhrc", notes: "eouehnn"),
        Word(key: "heorhrc", notes: "eouehnn"),
        Word(key: "heorhrc", notes: "eouehnn"),
        Word(key: "heorhrc", notes: "eouehnn")
    ]
    
    return ListView(words: words)
        .environmentObject(UndoManager())
}
