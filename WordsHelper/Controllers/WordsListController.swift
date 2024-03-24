//
//  WordsListController.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/1/20.
//

import Foundation

/// A type that manages a `WordsList`.
public final class WordsListController: CollectionFileController {
    /// Whether the file can be modified.
    ///
    /// Allow editing only if `true`.
    public let readOnly: Bool
    
    /// The content of the file.
    private var doc: WordsList
    
    /// The filename of the `doc`.
    public var filename: String {
        get { doc.name }
        set(name) { doc.name = name }
    }
    
    /// The language of words stored in `doc`.
    public var language: String {
        get { doc.language }
        set(lang) { doc.language = lang }
    }
    
    /// Create a `WordsListController` from a `WordsList`.
    ///
    /// - Parameters:
    ///    - doc: the `WordsList` object that the controller will manage.
    public init(_ doc: WordsList) {
        readOnly = doc.readOnly
        self.doc = doc
    }
}
