//
//  BackForthIterator.swift
//  WordsHelper
//
//  Created by Mark Liu on 2024/5/17.
//

import Foundation

/// An iterator of collection that can go back and forth.
public class BackForthIterator<T: Collection<E>, E>: IteratorProtocol {
    public typealias Element = E
    
    /// The collection to be read.
    private var collection: T
    
    /// Current index of the iterator.
    private var index: T.Index
    
    /// Intiate a `BackForthIterator` using a collection.
    public init(_ collection: T) {
        self.collection = collection
        self.index = collection.startIndex
    }
    
    /// Test if the previous index is valid.
    ///
    /// - Returns: a boolean indicating if the previous index is valid.
    public func hasPrev() -> Bool {
        return index > collection.startIndex
    }
    
    /// Get the previous element in the collection and moves index backward.
    ///
    /// - Returns: the previous element or `nil` if reaching the head.
    public func prev() -> E? {
        if (index <= collection.startIndex) {
            return nil
        }
        
        index = collection.index(index, offsetBy: -1)
        return collection[index]
    }
    
    /// Get the current element.
    ///
    /// - Returns: element at the current `index`.
    public func curr() -> E {
        return collection[index]
    }
    
    /// Test if the next index is valid.
    ///
    /// - Returns: a boolean indicating if the previous index is valid.
    public func hasNext() -> Bool {
        return index < collection.index(collection.endIndex, offsetBy: -1)
    }
    
    /// Get the next element in the collection and moves index forward.
    ///
    /// - Returns: the next element or `nil` if reaching the end.
    public func next() -> E? {
        if (index >= collection.index(collection.endIndex, offsetBy: -1)) {
            return nil
        }
        
        index = collection.index(index, offsetBy: 1)
        return collection[index]
    }
}

// MARK: - Other Utils

extension BackForthIterator {
    /// The position of the current pointer of the iterator.
    var currentIndex: T.Index { index }
    
    /// The next index of the iterator.
    var nextIndex: T.Index { collection.index(after: index) }
    
    /// The size of the collection being iterated.
    var count: Int { collection.count }
    
    /// Set the index of the iterator to a specific index.
    ///
    /// - Parameter index: the index where the iterator will be set to.
    /// - Throws: `indexOutOfRangeException` when the index is invalid.
    public func setIndex(_ index: T.Index) throws {
        if (index < collection.startIndex || index >= collection.endIndex) {
            throw BackForthIteratorError
                .indexOutOfRangeException("Index out of range")
        }
        
        self.index = index
    }
}

