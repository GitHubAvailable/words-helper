//
//  EditorView.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/1/21.
//

import SwiftUI

struct EditorView: View {
    /// The words list to be edited.
    @ObservedObject var document: WordsList
    
    /// The `UndoManager` that stores all changes.
    @EnvironmentObject var undoManager: UndoManager
    
    /// Wether the info about the words list itself should be displayed.
    @State private var showInfo: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                WordsListView()
                    .environmentObject(document.words)
                    .environmentObject(undoManager)
            }
            // FIXME: navigationTitle not updated after renamed in iOS 17.
            .navigationTitle(document.name) // editbable of 16.0
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    infoButton
                    // saveButton
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    // shareButton
                    //Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// The button that enters the words list info page.
    var infoButton: some View {
        Button {
            showInfo.toggle()
        } label: {
            Image(systemName: "list.dash")
        }
        .sheet(isPresented: $showInfo) {
            // need to think about other parameters
            ListInfoEditor(lang: $document.language)
                .onChange(of: document.language) { [old = document.language] new in
                    undoManager.registerUndo(withTarget: document) { doc in
                        doc.language = old
                    }
                }
        }
    }
    
    /*
    /// The button that controls sharing the words list file.
    var shareButton: some View {
        Button {
            
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
    */
    
    /*
    var saveButton: some View {
        Button {
            
        } label: {
            Image(systemName: "square.and.arrow.down")
        }
    }
     */
}

#Preview {
    let wordsList = try! WordsList(path: Bundle.main.url(
        forResource: "sample_data1",
        withExtension: "json")!
    )
    return EditorView(document: wordsList)
        //.environmentObject(wordsList)
        .environmentObject(UndoManager())
}
