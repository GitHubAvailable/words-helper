//
//  LearningView.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/16.
//

import Foundation
import SwiftUI

/// A type that represents the word display page
/// at a certain learning stage.
protocol LearningView: View {
    /// Get the previous `Word`.
    ///
    /// - throws: an exception when reaching the end.
    mutating func prev() throws
    
    /// Get the next `Word`.
    /// 
    /// - throws: an exception when reaching the end.
    mutating func next() throws
    
    /// Get the progress of current stage as a string.
    func getProgress() -> String
}
