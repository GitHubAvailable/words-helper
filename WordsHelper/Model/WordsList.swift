//
//  WordsList.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/4/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

/// SnapShot structure used for JSON encoding.
public struct WordsListPackage: Codable {
    var language: String
    var words: [Word]
    
    init(_ language: String? = nil, _ words: [Word]) {
        self.language = language ?? String(localized: "未知")
        self.words = words
    }
}

/// An object that store a list of words.
public final class WordsList : Identifiable, ReferenceFileDocument, ObservableObject {
    
    /// Adding more than one type may make new file without extension.
    public static var readableContentTypes: [UTType] { [
        // UTType.text,
        UTType.json
    ] }
    
    /// The directory of the file.
    ///
    /// May not be given if created from `DocumentGroup`.
    private var path: URL? = nil
    
    /// filename
    @Published public var name: String
    
    /// Language of the words in the list.
    ///
    /// May create an enum in the future.
    @Published public var language: String
    
    /// If the file is editable.
    ///
    /// Logic for non-editable file not implemented yet, as learning system
    /// needs editable proficiency to determine where the user needs
    /// more practice.
    public let readOnly: Bool
    
    /// A list that stores all words while monitoring if they are duplicated.
    @Published public var words: MonitoredArray<String, Word>
    
    /// Create empty wordsList, called by `DocumentGroup`
    public init() {
        name = String(localized: "無題")
        language = String(localized: "未知")
        readOnly = false
        words = try! MonitoredArray(key: "key")
    }
    
    /// Create a file from a `FileWrapper`.
    ///
    /// - Parameter document: the file object that contains fileContent and metadata.
    public init(_ document: FileWrapper) throws {
        name = document.filename!
        
        guard let data: Data = document.regularFileContents
        else {
            throw DocumentError.parsingError(
                "Parsing Error: Document Parsing Failure"
            )
        }
        
        readOnly = document.fileAttributes[FileAttributeKey.appendOnly.rawValue] as? Bool ?? false
        
        let filecontent = try JSONDecoder().decode(WordsListPackage.self, from: data)
        
        language = filecontent.language
        words = try! MonitoredArray(key: "key", filecontent.words)
    }
    
    /// Called by `DocumentGroup` to read fileContent when opening a file.
    ///
    /// - Parameter configuration: Configuration object supported by
    /// document group when opening document.
    public required convenience init(configuration: ReadConfiguration) throws {
        let document: FileWrapper = configuration.file
        try self.init(document)
    }
    
    /// Load a `WordsList` from given path.
    ///
    /// Get `FileWrapper` from gives path and then initiate.
    ///
    /// - Parameter path: a path that the wordlist is located.
    public convenience init(path: URL) throws {
        let document: FileWrapper
        document = try FileWrapper(url: path)
        try self.init(document)
        self.path = path
    }
    
    /// Create a copy from a given `WordsList`.
    ///
    /// - Parameter document: a `WordsList` that already exists.
    public init(from document: WordsList) {
        name = document.name
        language = document.language
        readOnly = document.readOnly
        
        var arr: [Word] = []
        for word in document.words {
            arr.append(word.copy() as! Word)
        }
        
        words = try! MonitoredArray(key: "key", arr)
    }
    
    public func getURL() -> URL? {
        return path
    }
    
    public func setURL(url: URL) {
        self.path = url
    }
    
    /// Provide a current state of the file document.
    ///
    /// Conformance to `ReferenceFileDocument`, called by background threads.
    ///
    /// - Parameter contentType: a specified file type from the background thread.
    /// - Returns: the current state of this `WordsList`.
    public func snapshot(contentType: UTType) throws -> WordsListPackage {
        let data = WordsListPackage(language, words.data)
        return data
    }
    
    /// Save the current `WordsList`
    ///
    /// Conformance to `ReferenceFileDocument`, called by background threads
    /// only when creating the document or there are changes registered
    /// in the `UndoManager`.
    ///
    /// - Parameters:
    ///   - snapshot: the current state of this `WordsList`.
    ///   - configruation: configuration about the existing file supported by the system.
    /// - Returns: a `FileWrapper` that contains the modified version of the file.
    public func fileWrapper(
        snapshot: WordsListPackage,
        configuration: WriteConfiguration
    ) throws -> FileWrapper {
        let data = try Self.encodeData(snapshot)
        let fileWrapper: FileWrapper = FileWrapper(regularFileWithContents: data)
        
        return fileWrapper
    }
    
    /// Save the content to a specific directory in a given format.
    ///
    /// Only json format is supported for now.
    ///
    /// - Parameters:
    ///   - path: the target directory.
    ///   - type: the specified output format.
    public func write(to path: URL, contentType type: UTType) throws {
        do {
            let content: Data = try Self.encodeData(snapshot(contentType: type))
            try content.write(to: path, options: [.atomic])
        } catch {
            throw DocumentError.encodingError(
                "Encoding Error: file encoding failure"
            )
        }
    }
    
    /// Encode the given input data.
    ///
    /// - Parameter data: the input file data.
    /// - Returns: JSON formatted data
    public static func encodeData<DATA: Encodable>(_ data: DATA) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys, .prettyPrinted]
        let content: Data = try encoder.encode(data)
        return content
    }
}

// MARK: - Basic Editing Functions

extension WordsList {
    
    /// Add an item to the `WordsList` and register an undo, if needed.
    ///
    /// - Parameters:
    ///    - item: the `Word` to be added.
    ///    - at: the index where the `Word` will be added to.
    ///    - undoManager: the `UndoManager` used to record change.
    public func addItem(
        _ item: Word,
        at pos: Int? = nil,
        undoManager: UndoManager? = nil
    ) {
        let index = pos ?? words.endIndex
        try! words.insert(item, at: index)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            withAnimation {
                // should not pass undoManager again as this is undo
                doc.removeItem(at: index)
            }
        }
    }
    
    /// Delete an item from the given index of the `WordsList` and register an undo, if needed.
    ///
    /// - Parameters:
    ///    - at: the index where the `Word` will be deleted.
    ///    - undoManager: the `UndoManager` used to record change.
    public func removeItem(at index: Int, undoManager: UndoManager? = nil) {
        let target: Word = words[index]
        
        if !(words.freq(target.key) == 0) {
            return
        }
        words.remove(at: index)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            withAnimation {
                try! doc.words.insert(target, at: index)
            }
        }
    }
    
    /// Delete selected items from the given index of the `WordsList`
    /// and register undo in order, if needed.
    ///
    /// - Parameters:
    ///    - at: an `IndexSet` of indices of all `Word` to be deleted.
    ///    - undoManager: the `UndoManager` used to record change.
    public func removeItems(
        at indices: IndexSet,
        undoManager: UndoManager? = nil
    ) {
        for index in indices {
            removeItem(at: index, undoManager: undoManager)
        }
    }
    
    /// Swap two words of the `WordsList`and register undo in order, if needed.
    ///
    /// - Parameters:
    ///    - firstIndex: index of one `Word` to be swapped.
    ///    - secondIndex: index of the other `Word` to be swapped.
    ///    - undoManager: the `UndoManager` used to record change.
    public func swapItem(
        _ i: Int,
        _ j: Int,
        undoManager: UndoManager? = nil
    ) {
        words.swap(i, j)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            withAnimation {
                doc.words.swap(j, i)
            }
        }
    }
}
