//
//  SelectionView.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/17.
//

import SwiftUI

struct SelectionView<C: Collection<Word>>: LearningView {
    /// The current `Word` to be displayed.
    @ObservedObject var word: Word
    
    /// The `UndoManager` used to save progress.
    @EnvironmentObject private var undoManager: UndoManager
    
    /// The options to be displayed for the current word.
    private let options: Set<String>
    
    /// The iterator used to get the `Word` to be displayed.
    private var iter: BackForthIterator<C, Word>
    
    init(_ words: C, _ optionSet: Set<String>? = nil) {
        self.options = optionSet ?? Self.getOptionSet(words)
        self.iter = BackForthIterator(words)
        self.word = iter.curr()
    }
    
    var body: some View {
        VStack(alignment:.center) {
            DefaultHeader(word.key, word.pronounce)
            
            Spacer()
            
            selector
                .padding(
                    EdgeInsets(
                        top: 15,
                        leading: 0,
                        bottom: 30,
                        trailing: 0)
                )
            
            Spacer()
        }
        .padding(.horizontal, 40)
        
        Divider()
        ProficiencySelector(word: word)
            .environmentObject(undoManager)
        Divider()
        Spacer()
    }
    
    /// The selector view to be displayed.
    var selector: SimpleSelector {
        let question = getOptions()
        
        return SimpleSelector(
            options: question.0,
            correct: question.1
        )
    }
    
    mutating func prev() throws {
        if !(iter.hasPrev()) {
            throw BackForthIteratorError
                .indexOutOfRangeException("Index out of range")
        }
        
        word = iter.prev()!
        // need to change
    }
    
    mutating func next() throws {
        if !(iter.hasNext()) {
            throw BackForthIteratorError
                .indexOutOfRangeException("Index out of range")
        }
        
        word = iter.next()!
    }
    
    func getProgress() -> String {
        return "(\(iter.nextIndex)/\(iter.count))"
    }
    
    /// Load the available options from the given word list.
    private static func getOptionSet(_ words: C) -> Set<String> {
        var options: Set<String> = []
        
        for word in words {
            options.insert(word.notes)
        }
        
        return options
    }
    
    /// Generate the options for the current `word`.
    ///
    /// - Returns: a tuple contains a list of strings as options
    ///   and set of index of correct answers.
    private func getOptions() -> ([String], Set<Int>) {
        var choices: Set<String> = [word.notes]
        
        for option in options {
            choices.insert(option)
            
            if choices.count >= 4 {
                break
            }
        }
        
        if choices.count <= 1 {
            return (Array(choices), Set([0]))
        }
        
        let options = Array(choices)
        return (options, Set([options.firstIndex(of: word.notes)!]))
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
    let words: [Word] = [word]
    
    return SelectionView(words)
        .environmentObject(UndoManager())
}
