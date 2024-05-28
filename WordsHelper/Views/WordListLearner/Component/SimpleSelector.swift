//
//  SimpleSelector.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/18.
//

import SwiftUI

/// The available border colors of an option.
fileprivate let correctColor: Color = .green
fileprivate let wrongColor: Color = .red
fileprivate let defaultColor: Color = .gray

struct SimpleSelector: View {
    /// The list of options to be displayed.
    let options: [String]
    
    /// The set of index of correct options.
    let correct: Set<Int>
    
    /// The set of index of selected options.
    @State var selected: Set<Int>
    
    init(options: [String], correct: Set<Int>, selected: Set<Int> = []) {
        self.options = options
        self.correct = correct
        self.selected = selected
    }
    
    var body: some View {
        VStack {
            ForEach(0..<options.count) { index in
                SingleSelection(
                    text: options[index]
                )
                .onTapGesture {
                    selected.insert(index)
                }
                .border(getColor(index))
                .disabled(selected.contains(index))
                .padding(.vertical, 5)
            }
            
            HStack {
                Spacer()
                
                Button {
                    selected.removeAll()
                } label: {
                    Image(systemName: "trash")
                        .scaleEffect(CGSize(width: 1.1, height: 1.1))
                }
            }
        }
    }
    
    /// Get the border color for the option at specified index.
    ///
    /// - Parameter index: the index of the option to be calculated.
    private func getColor(_ index: Int) -> Color {
        if (!selected.contains(index)) {
            return defaultColor
        }
        return correct.contains(index) ? correctColor : wrongColor
    }
}

#Preview {
    let options: [String] = ["Test a", "test b", "test c", "test d"]
    return SimpleSelector(
        options: options,
        correct: Set([2])
    )
}
