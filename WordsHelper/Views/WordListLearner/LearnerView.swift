//
//  LearnerView.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/16.
//

import SwiftUI

/// The discription of each stage.
fileprivate let stageDescription: [String] = [
    String(localized: "一 初識"),
    String(localized: "二 回頋"),
    String(localized: "三 強化"),
    String(localized: "四 詳解"),
    String(localized: "五 總覽"),
    String(localized: "六 測驗")
]

/// The type of view of each learning stage.
fileprivate let cardStage: Set<Int> = [1, 2, 4]
fileprivate let selectionStage: Set<Int> = [3, 6]
fileprivate let listStage: Set<Int> = [5]

/// A view that represents main page of the learning system.
struct LearnerView: View {
    /// The current learning stage.
    @State private var stage: Int = 1
    
    /// The word list to be learned.
    @State var words: [Word]
    
    /// The learning page of the current stage to be displayed.
    @State private var curPage: any LearningView
    
    /// The `UndoManager` used to save progress.
    @EnvironmentObject private var undoManager: UndoManager
    
    /// The options for selection stages.
    let options: Set<String>
    
    /// The stages that only display unfamiliar words.
    ///
    /// Will be skiped of no available words.
    let unfamiliarOnlyStage: Set<Int> = [2, 3]
    
    init(words: [Word]) {
        self.words = words
        self.curPage = CardView(words)
        self.options = Self.getOptionSet(words)
        
        // Display words in increasing proficiency.
        self.words.sort { word1, word2 in
            return word1.proficiency.rawValue <= word2.proficiency.rawValue
        }
    }
    
    var body: some View {
        VStack {
            if (cardStage.contains(stage)) {
                curPage as! CardView<[Word]>
            }
            else if (selectionStage.contains(stage)) {
                curPage as! SelectionView<[Word]>
            }
            else if (listStage.contains(stage)) {
                curPage as! ListView
            }
        }
        .navigationTitle(Text(title))
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                prev
                next
            }
        }
    }
    
    /// The button to go to the previous word or stage.
    ///
    /// Has no effect on the first word of the first stage.
    var prev: some View {
        Button {
            do {
                try curPage.prev()
            } catch {
                while stage > 1 {
                    stage -= 1
                    
                    let data: [Word] = unfamiliarOnlyStage.contains(stage) ?
                    unfamiliar : words
                    
                    if !(data.isEmpty) {
                        setView()
                        return
                    }
                }
            }
        } label: {
            Image(systemName: "arrowtriangle.left")
        }
    }
    
    /// The button to go to the next word or stage.
    ///
    /// Has no effect on the last word of the last stage.
    var next: some View {
        Button {
            do {
                try curPage.next()
            } catch {
                organizeList()
                
                while stage < 6 {
                    stage += 1
                    
                    let data: [Word] = unfamiliarOnlyStage.contains(stage) ?
                    unfamiliar : words
                    
                    if !(data.isEmpty) {
                        setView()
                        return
                    }
                }
            }
        } label: {
            Image(systemName: "arrowtriangle.right")
        }
    }
    
    /// Filter out the unfamilar words (`Proficiency` less than 3).
    private var unfamiliar: [Word] {
        return words.filter({ word in
            word.proficiency.rawValue <= 3
        })
    }
    
    /// The current progress of the learning stage.
    var title: String {
        return [stageDescription[stage - 1], curPage.getProgress()].joined(separator: " ")
    }
    
    /// Sort the list in increasing proficiency.
    private func organizeList() {
        words.sort { word1, word2 in
            return word1.proficiency.rawValue <= word2.proficiency.rawValue
        }
    }
    
    /// Set the view to be displayed.
    private func setView() {
        switch stage {
        case 1:
            curPage = CardView(words)
        case 2:
            curPage = CardView(unfamiliar)
        case 4:
            curPage = CardView(words, true)
        case 5:
            curPage = ListView(words: words)
        case 6:
            curPage = SelectionView(words, options)
        default:
            curPage = SelectionView(unfamiliar,
                options
            )
        }
    }
    
    /// Load the available options from the given word list.
    private static func getOptionSet(_ words: [Word]) -> Set<String> {
        var options: Set<String> = []
        
        for word in words {
            options.insert(word.notes)
        }
        
        return options
    }
}

#Preview {
    let word: Word = Word(
        key: "test",
        notes: "hdrchg",
        detail: "o,eoueoeuhircohcarhubrebntbkntabnbj",
        pronounce: ",eu",
        proficiency: .level3
    )
    let word1: Word = Word(
        key: "teoeuidst",
        notes: "g",
        detail: "o,eoueoeuhhubrebntbkntabnbj",
        pronounce: ",eu.gcrgde",
        proficiency: .level2
    )
    let word2: Word = Word(
        key: "tkeaknknn",
        notes: "hdhrhcrhcrhchg",
        detail: "o,eoueoeuhibkntabnbj",
        pronounce: ",eu.cgde",
        proficiency: .level3
    )
    let wordsList: [Word] = [word, word1, word2]
    
    return NavigationView {
        LearnerView(words: wordsList)
            .environmentObject(UndoManager())
    }
}
