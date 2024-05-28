//
//  ProficiencySelector.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/19.
//

import SwiftUI

struct ProficiencySelector: View {
    /// The `Word` where its proficiency is to be modified.
    @ObservedObject var word: Word
    
    /// The `UndoManager` used to save progress.
    @EnvironmentObject private var undoManager: UndoManager
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                
                ForEach(Proficiency.allCases) { level in
                    Button {
                        word.proficiency = level
                        undoManager.registerUndo(withTarget: word, handler: {word in })
                    } label: {
                        Image(systemName: "star.fill")
                            .tint(word.proficiency.rawValue < level.rawValue ? .gray : .green)
                    }
                    .frame(width: 40, height: 40)
                    .scaleEffect(2)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            
            Text(Proficiency.notes[word.proficiency]!)
                .foregroundStyle(.secondary)
                .font(.headline)
                .padding(.vertical, 5)
                .padding(.bottom, 10)
        }
    }
}

#Preview {
    var word: Word = Word(key: "key here")
    
    return ProficiencySelector(word: word)
        .environmentObject(UndoManager())
}
