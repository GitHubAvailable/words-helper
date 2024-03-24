//
//  Proficiency.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/9/24.
//

import Foundation

/// An enum that stores different lever of familiarity with the word.
///
/// Make each member visible in Objective-C to support KVC.
@objc
public enum Proficiency: Int, Codable, IterPickable, Identifiable, CaseIterable {
    /// Stardard format description used for display.
    public var description: String {
        String("\(self.rawValue) - \(Self.notes[self]!)")
    }
    
    /// id of a proficiency.
    ///
    /// Used for iteration.
    public var id: Int {
        self.rawValue
    }
    
    /// Brief description of each level of `Proficiency`.
    public static let notes: [Proficiency : String] = [
        .level1 : String(localized: "陌生"),
        .level2 : String(localized: "印象"),
        .level3 : String(localized: "記得"),
        .level4 : String(localized: "熟悉"),
        .level5 : String(localized: "牢記"),
    ]
    
    /// Familiarity with a word on a scale of 1 to 5,
    /// from unfamiliar to familiar.
    case level1 = 1;
    case level2 = 2;
    case level3 = 3;
    case level4 = 4;
    case level5 = 5;
}

// MARK: - Utils

extension Proficiency {
    /// Get description of specific `Proficiency` by id.
    ///
    /// - Parameters:
    ///    - id: the id (i.e., the rawvalue) of the desired `Proficiency`.
    public static func getDescriptionById(_ id: Int) -> String {
        return Proficiency(rawValue: id)!.description
    }
}
