//
//  DocumentError.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/5/24.
//

import Foundation

/// A static factory that creates error object related to reading and
/// writing `WordsList` documents.
class DocumentError: ProgramError {
    /// Create `DocumentError` that indicates that the file data
    /// is invalid or empty.
    static func parsingError(_ note: String) -> DocumentError {
        return DocumentError(code: 1001, msg: note)
    }
    
    /// Create `DocumentError` that indicates that the current`WordsList`
    /// failed to get encoded and saved.
    static func encodingError(_ note: String) -> DocumentError {
        return DocumentError(code: 1002, msg: note)
    }
    
    /// Create `DocumentError` that indicates that the current
    /// `WordsList` cannot be decoded.
    ///
    /// Currently not used.
    static func decodingError(_ note: String) -> DocumentError {
        return DocumentError(code: 1003, msg: note)
    }
    
    /// Creates `DocumentError` object that indicates that another `WordsList`
    /// with the same file name has already exist.
    ///
    /// Currently not used.
    static func itemAlreadyExistException(_ note: String) -> DocumentError {
        return DocumentError(code: 1004, msg: note)
    }
    
    /// Construct a general `DocumentError` object.
    ///
    /// Private constructor used by static functions.
    private override init(code: Int, msg: String) {
        super.init(code: code, msg: msg)
    }
}
