//
//  DataError.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/8/24.
//

import Foundation

/// A static factory that creates error object related to processing data
/// for `WordsList` documents.
class DataError: ProgramError {
    /// Create `DataError` that indicates the attribute specified
    /// by given name does not exist.
    ///
    /// - Parameter note: The error message to be displayed.
    static func labelNonexistException(_ note: String) -> DataError {
        return DataError(code: 2001, msg: note)
    }
    
    /// Create `DataError` that indicates the attribute specified
    /// by given name cannot be set to given value.
    ///
    /// Currently not used.
    static func typeMismatchException(_ note: String) -> DataError {
        return DataError(code: 2002, msg: note)
    }
    
    /// Construct a general `DataError` object.
    ///
    /// Private constructor used by static functions.
    private override init(code: Int, msg: String) {
        super.init(code: code, msg: msg)
    }
}
