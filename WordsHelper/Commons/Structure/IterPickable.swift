//
//  IterPickable.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/9/24.
//

import Foundation

/// A type that can be listed and selected.
public protocol IterPickable:
    Hashable,
    CaseIterable,
    Identifiable,
    RawRepresentable,
    CustomStringConvertible
where AllCases == [Self] {
    
}
