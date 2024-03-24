//
//  WordRowView.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/5/24.
//

import SwiftUI
import UIKit

/// A expandable view that displays editable field of specific `Word`.
struct WordRowView: View {
    
    /// The `Word` to be displayed.
    @ObservedObject var word: Word
    
    /// The `UndoManager` that stores all changes.
    let undoManager: UndoManager
    
    /// Whether the detail should be displayed.
    @State var showDetail: Bool = false
    
    /// The frequency of words with the same `key` appears
    /// in the words list.
    var freq: (String) -> Int
    
    /// An object that tract and report changes of `Word`.
    var keyReporter: NSKeyValueObservation
    
    /// Create a `WordRowView` of specified word that monitors
    /// frequency of keys.
    init(word: Word,
         freq: @escaping (String) -> Int = {_ in 1},
         report: @escaping (String, String, UndoManager?) -> Void = {_, _, _  in },
         undoManager: UndoManager
    ) {
        self.word = word
        self.freq = freq
        self.undoManager = undoManager
        
        // Register this view as observer of `Word`.
        self.keyReporter = word.observe(\.key, options: [.old, .new]) { term, change in
            report(change.oldValue!, change.newValue!, undoManager)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(word.key)
                    .font(.headline)
                    .bold()
                    .frame(alignment: .center)
                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 8))
                    
                Text(word.notes)
                
                Spacer()
                
                if freq(word.key) > 1 {
                    Label("\(freq(word.key))", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                        .background(.clear)
                }
                
                Button {
                    withAnimation {
                        showDetail.toggle()
                    }
                } label: {
                    Label("showDetail", systemImage: "arrowtriangle.down.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(Angle(degrees: showDetail ? 0 : 90))
                }
                .padding(.trailing, 10)
            }
            
            if showDetail {
                WordDetail()
                    .environmentObject(word)
                    .frame(minHeight: 270)
                    .padding(0)
            } else {
                Spacer()
            }
        }
    }
}

#Preview {
    let word: Word = Word(key: "test word", notes: "test notes")
    
    return WordRowView(word: word, undoManager: UndoManager())
}
