//
//  BackForthIteratorError.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/21.
//

import Foundation

/// An enum that represents the error of `BackForthIterator`.
public enum BackForthIteratorError: Error {
    /// A case that represents the exception caused by accessing
    /// an invalid index.
    case indexOutOfRangeException(String)
}
