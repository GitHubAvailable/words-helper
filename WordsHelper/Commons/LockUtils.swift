//
//  LockUtils.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/13/24.
//

import Foundation

/// A toolset class that manages locks for concurrency.
///
/// Will be used for collaborate editing.
public class LockUtils {
    /// Lock the resource for resource and release whenevr done.
    ///
    /// - Parameter action: the operation to be performed when resources is locked.
    static func lock<T>(_ action: () throws -> T) throws -> T {
        let lock = NSLock()
        lock.lock()
        defer { lock.unlock() }
        return try action()
    }
}
