//
//  ContentView.swift
//  WordsHelper
//
//  Created by Mark Liu on 12/23/23.
//

import SwiftUI

struct ContentView: View {
    /// The words list to be edited.
    @EnvironmentObject var document: WordsList
    
    /// The `UndoManager` that records changes.
    @Environment(\.undoManager) var undoManager: UndoManager?
    
    var body: some View {
        EditorView(document: document)
            //.environmentObject(document)
            .environmentObject(undoManager!)
    }
}

#Preview {
    let wordsList = try! WordsList(path: Bundle.main.url(
        forResource: "sample_data1", withExtension: "json")!)
    return ContentView()
        .environmentObject(wordsList)
        .tint(.green)
        .preferredColorScheme(.dark)
        .foregroundStyle(.green)
        .navigationBarColor(titleColor: .green)
}
