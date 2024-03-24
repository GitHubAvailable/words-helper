//
//  FileController.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/1/20.
//

import Foundation

/// A type that manages the file attributes of a file/folder.
public protocol FileController {
    /// Whether the file can be modified.
    var readOnly: Bool { get }
}
