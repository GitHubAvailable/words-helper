//
//  CardView.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/17.
//

import SwiftUI

struct CardView<C: Collection<Word>>: LearningView {
    /// The current `Word` to be displayed.
    @ObservedObject private var word: Word
    
    /// The `UndoManager` used to save progress.
    @EnvironmentObject private var undoManager: UndoManager
    
    /// The iterator used to get the `Word` to be displayed.
    private var iter: BackForthIterator<C, Word>
    
    /// Whether the `detail` field should be displayed.
    private var showDetail: Bool
    
    init(_ words: C, _ showDetail: Bool = false) {
        self.iter = BackForthIterator(words)
        self.word = iter.curr()
        self.showDetail = showDetail
    }
    
    var body: some View {
        VStack(alignment:.center) {
            DefaultHeader(word.key, word.pronounce)
            
            HStack {
                Text(word.notes)
                    .font(.system(size: 25))
                    .padding(.bottom, 10)
                Spacer()
            }
            
            if (showDetail) {
                TextEditor(text: .constant(word.detail))
                    .border(.gray, width: 3)
                    .padding(.bottom, 10)
            }
            else { Spacer() }
        }
        .padding(.horizontal, 40)
        
        Divider()
        ProficiencySelector(word: word)
            .environmentObject(undoManager)
        Divider()
    }
    
    mutating func prev() throws {
        if !(iter.hasPrev()) {
            throw BackForthIteratorError
                .indexOutOfRangeException("Index less than `startIndex`")
        }
        
        word = iter.prev()!
    }
    
    mutating func next() throws {
        if !(iter.hasNext()) {
            throw BackForthIteratorError
                .indexOutOfRangeException("Index exceed the last element")
        }
        
        word = iter.next()!
    }
    
    func getProgress() -> String {
        return "(\(iter.nextIndex)/\(iter.count))"
    }
}

#Preview {
    let word: Word = Word(
        key: "test",
        notes: "hdrchg",
        detail: "o,eoueoeuhircohcarhubrebntbkntabnbj",
        pronounce: ",eu.e",
        proficiency: .level3
    )
    let wordsList: [Word] = [word]
    
    return CardView(wordsList, true)
        .environmentObject(UndoManager())
}
