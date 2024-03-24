//
//  ObservableNSObj.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/9/24.
//

import Foundation

/// Enable updating view when value changes.
extension NSObject: ObservableObject {
    
}

// MARK: - Set/Get functions that raises Error for nonexistent keys

extension NSObject {
    /// Get the value of attribute by its name.
    ///
    /// Despite the warning, error can happen when the attribute
    /// does not exist.
    func getByKey(_ forKey: String) throws -> Any? {
        do {
            return try self.value(forKey: forKey)
        } catch {
            throw DataError.labelNonexistException("key does not exist")
        }
    }
    
    /// Set the value of specific attribute by its name.
    func update(_ val: Any?, forKey: String) throws {
        do {
            try self.setValue(val, forKey: forKey)
        } catch {
            throw DataError.labelNonexistException("key does not exist")
        }
    }
}
