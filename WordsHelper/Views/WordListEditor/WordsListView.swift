//
//  WordsListView.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/16/24.
//

import SwiftUI

struct WordsListView: View {
    /// The words list to be displayed.
    @EnvironmentObject var words: MonitoredArray<String, Word>
    
    /// The `UndoManager` that stores all changes.
    @EnvironmentObject var undoManager: UndoManager
    
    /// Whether only display words with `Proficiency` less than 3.
    @State private var showUnfamiliarOnly: Bool = false
    
    /// The specified proficiency to be displayed.
    ///
    /// Default is `1-5`.
    @ObservedObject private var proficiencyShown: ObservableWrapper<[Bool]> = ObservableWrapper( [Bool](repeating: true, count: 5))
    
    /// Whether the list is in editing mode.
    ///
    /// @Environment(\.editMode) causes error here.
    @State private var isEditing: EditMode = .inactive
    
    /// The words being selected.
    @State private var selections = Set<UUID>() // depend on id
    
    /// - Returns: if words at input proficiency should be displayed.
    func shouldAppear(_ proficiency: Proficiency) -> Bool {
        (!showUnfamiliarOnly || proficiency.rawValue <= 3) &&
        (proficiencyShown.wrappedObject[proficiency.rawValue - 1])
    }
    
    /// - Returns: the list of words need need to be displayed.
    var filteredWords: [Word] {
        words.filter { word in
            shouldAppear(word.proficiency)
        }
    }
    
    /// The least level of `Proficiency` that can be displayed,
    /// return `.level1` if not available.
    var leastProficiency: Proficiency {
        for i in 1...5 {
            if shouldAppear(Proficiency.init(rawValue: i)!) {
                return Proficiency(rawValue: i)!
            }
        }
        return .level1
    }
    
    var body: some View {
        VStack {
            List(selection: $selections) {
                ForEach(filteredWords) { word in
                    WordRowView(
                        word: word,
                        freq: words.freq,
                        report: words.updateValueOfKey,
                        undoManager: undoManager
                    )
                        .listRowSeparator(.visible)
                    // pass undoManager
                }
                .onMove { indices, newOffset in
                    words.move(
                        fromOffsets: indices,
                        toOffset: newOffset,
                        undoManager: undoManager
                    )
                }
                .onDelete { indexSet in
                    words.remove(
                        atOffsets: indexSet,
                        undoManager: undoManager
                    )
                }
                HStack {
                    Spacer()
                    Button {
                        try! words.insert(
                            Word(key: String(localized: "言"), proficiency: leastProficiency),
                            undoManager: undoManager
                        )
                    } label: {
                        Label("增", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                    Spacer()
                }
                .listRowSeparator(.hidden)
                // .foregroundStyle(.green)
            }
            .environment(\.editMode, $isEditing)
            .toolbar {
                // copypaste
                // insertButton
                ToolbarItemGroup {
                    editButton
                    deleteButton
                    filter
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    studyButton
                }
            }
            .listStyle(.inset)
            
            Divider()
            Text(stats)
            Divider()
        }
    }
    
    /// Statistics to be displayed.
    var stats: String {
        // Number of words.
        let totalLen = words.count
        
        // Number of words displayed.
        let shownLen = filteredWords.count
        
        // Number of words selected.
        let selectLen = selections.count
        
        // Create texts.
        let shown = String(localized: "\(totalLen)詞示\(shownLen)")
        let hidden = shownLen == totalLen ? "" : String(localized: "隱\(totalLen - shownLen)")
        let selected = selections.count == 0 ? "" : String(localized: "擇\(selectLen)")
        
        return "\(shown)\(hidden)\(selected)"
    }
    
    /*
    var insertButton: some View {
        Button("增", systemImage: "plus") {
            // TODO: call controller to add
        }
    }
     */
    
    /// Control buttons about edit mode.
    var editButton: some View {
        Button(isEditing.isEditing ? String(localized: "成") : String(localized: "纂")) {
            switch $isEditing.wrappedValue  {
            case .active:
                $isEditing.wrappedValue = .inactive
            case .inactive:
                $isEditing.wrappedValue = .active
            default:
                break
            }
        }
    }
    
    /// Delete button that delete all selected words.
    var deleteButton: some View {
        Button {
            var removedNum = 0
            let tasks = selections.count
            
            /// Delete from the end of the list.
            for index in stride(from: words.count - 1, through: words.startIndex, by: -1) {
                if removedNum == tasks {
                    break
                }
                if !selections.contains(words[index].id) {
                    continue
                }
                words.remove(at: index, undoManager: undoManager)
                removedNum += 1
            }
            selections.removeAll()
        } label: {
            Image(systemName: "trash")
        }
    }
    
    /// The menu that controls the filter.
    var filter: some View {
        Menu {
            ForEach(1..<6) { level in
                Toggle(
                    Proficiency.getDescriptionById(level),
                    isOn: $proficiencyShown.wrappedObject[level - 1]
                )
            }
            
            Divider()
            
            Toggle(
                String(localized: "僅生"),
                isOn: $showUnfamiliarOnly
            )
        } label: {
            Label(String(localized: "陳列項"), systemImage: "slider.horizontal.3")
        }
    }
    
    /// The button used to enter the learning system.
    var studyButton: some View {
        NavigationLink {
            if !(words.isEmpty) {
                LearnerView(words: words.data)
                    .environmentObject(undoManager)
            }
        } label: {
            Image(systemName: "arrowtriangle.right")
        }
        .disabled(words.isEmpty || words.getRepetitives() > 0)
    }
}

#Preview {
    do {
        @State var wordsList: WordsList = try WordsList(path: Bundle.main.url(
            forResource: "sample_data1",
            withExtension: "json")!
        )
        return NavigationView {
            WordsListView()
                .environmentObject(wordsList.words)
                .environmentObject(UndoManager())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        // displays bottom toolbar in learning system
    } catch {
        return EmptyView()
    }
}
