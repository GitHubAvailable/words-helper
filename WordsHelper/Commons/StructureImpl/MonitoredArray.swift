//
//  MonitoredArray.swift
//  WordsHelper
//
//  Created by Mark Liu on 1/11/24.
//

import Foundation
import os

/// A array that monitor specific attribute of object stored.
public class MonitoredArray<T: Hashable, E: NSObject>:
    MonitoredRandomAccessCollection,
    RandomAccessCollection,
    ObservableObject
{
    public typealias Element = E
    public typealias Index = Int
    public typealias Iterator = IndexingIterator<[E]>
    
    /// The attribute to be monitored.
    public let key: String
    
    /// A dictionary that map value of the value monitored
    /// attribute with its frequency.
    @Published private var freqs: [T : Int]
    
    /// Array that stores the objects.
    @Published private var arr: [E]
    
    /// Number of elements with the same value of monitored attribute.
    @Published private var repetitives: Int = 0
    
    /// Public API to access data stored.
    public var data: [E] { arr }
    
    /// First index of the array.
    ///
    /// Required by `RandomAccessCollection`.
    public let startIndex: Int = 0
    
    /// Index of where the next element will be appended.
    public var endIndex: Int { arr.endIndex }
    
    /// Estimated number of elements stored..
    ///
    /// Required by `RandomAccessCollection`.
    public var underestimatedCount: Int { arr.count }
    
    /// Number of elements stored.
    public var count: Int { arr.count }
    
    /// Create an `MonitoredArray` that monitors frequency of
    /// attributes specified by `key`.
    ///
    /// - Parameters:
    ///    - key: the name of attribute to be monitored.
    ///    - arr: the initial data stored in the array, default is `[]`.
    public init(key keyName: String, _ arr: [E] = []) throws {
        self.arr = arr
        self.key = keyName
        freqs = [:]
        
        for i in 0..<arr.count {
            let val: T
            do {
                val = try arr[i].getByKey(keyName) as! T
            } catch {
                fatalError("FATAL_ERROR: key and generic type mismatch or key \(keyName) does not exist for object at index \(i)!")
            }
            registerValue(val)
        }
    }
    
    /// Get-only subscript that access value at certain index.
    public subscript(position: Int) -> E {
        get { arr[position] }
    }
    
    /// Set the value of element at given index.
    ///
    /// - Parameters:
    ///    - element: the new object it will be set to.
    ///    - at: the index of the element to be set.
    ///    - undoManager: an `UndoManager` that records and can redo changes.
    public func setValue(
        _ element: E,
        at: Int,
        undoManager: UndoManager? = nil
    ) throws {
        let val: T
        let oldVal = try arr[at].value(forKey: key) as! T
        
        do {
            val = try element.getByKey(key) as! T
        } catch {
            fatalError("FATAL_ERROR: key and generic type mismatch or key \(key) does not exist for the object!")
        }
        updateValueOfKey(oldVal, val)
        arr[at] = element
        
        undoManager?.registerUndo(withTarget: self) { mArr in
            mArr.updateValueOfKey(val, oldVal)
        }
    }
    
    /// Update value of a certain attribute.
    ///
    /// Used for reporting change if one can directly access the element.
    ///
    /// - Parameters:
    ///    - oldValue: the original value of the attribute.
    ///    - newValue: the updated value of the attrubite.
    ///    - undoManager: an `UndoManager` that records and can redo changes.
    public func updateValueOfKey(
        _ oldValue: T,
        _ newValue: T,
        undoManager: UndoManager? = nil
    ) {
        if oldValue == newValue {
            return
        }
        unregisterValue(oldValue)
        registerValue(newValue)
        
        undoManager?.registerUndo(withTarget: self) { mArr in
            mArr.updateValueOfKey(newValue, oldValue)
        }
    }
    
    /// - Returns: the distribution of value of the monitored attribute.
    public func distribution() -> [T : Int] {
        return freqs
    }
    
    /// Increase the frequency for a certain 
    /// value of the monitored attribute by 1.
    ///
    /// - Parameter val: the value of the attribute that will be updated to.
    private func registerValue(_ val: T) {
        if freqs[val] == nil {
            freqs[val] = 0
        }
        
        if freqs[val] == 1 {
            repetitives += 1
        }
        freqs[val]! += 1
    }
    
    /// Increase the frequency for a certain
    /// value of the monitored attribute by 1.
    ///
    /// - Parameter val: the original of the attribute to be changed/removed.
    private func unregisterValue(_ val: T) {
        if freqs[val] == 2 {
            repetitives -= 1
        }
        
        freqs[val]! -= 1
        if freqs[val] == 0 { freqs.removeValue(forKey: val) }
    }
    
    /// - Returns: the number of elements that have the same value of the
    /// monitored attribute.
    public func getRepetitives() -> Int { repetitives }
    
    /// - Returns: the frequency of specific value of the monitored attibute.
    public func freq(_ sample: T) -> Int {
        return freqs[sample] ?? 0
    }
    
    /// Create an iterator of the array.
    ///
    /// - Returns: iterator of the array.
    public func makeIterator() -> Iterator {
        arr.makeIterator()
    }
}

// MARK: - CRUD functions

extension MonitoredArray {
    /// Append an element to the array.
    ///
    /// - Parameters:
    ///    - element: the new object it will be set to.
    ///    - undoManager: an `UndoManager` that records and can redo changes.
    public func insert(_ element: E, undoManager: UndoManager? = nil) throws {
        try insert(element, at: arr.endIndex, undoManager: undoManager)
    }
    
    /// Insert an element to certain index.
    ///
    /// - Parameters:
    ///    - element: the new object it will be set to.
    ///    - at: the index of the element to be set.
    ///    - undoManager: an `UndoManager` that records and can redo changes.
    public func insert(
        _ element: E,
        at index: Int,
        undoManager: UndoManager? = nil
    ) throws {
        let val: T
        
        do {
            // See if the element has the monitored attribute.
            val = try element.getByKey(key) as! T
        } catch {
            throw fatalError("FATAL_ERROR: the element lacks targeted key \(key)")
        }
        
        insert(element, at: index, val: val)
        
        // Record changes.
        undoManager?.registerUndo(withTarget: self) { mArr in
            mArr.remove(at: index, val: val)
        }
    }
    
    /// Insert the element to specified index with
    /// value of the monitored key specified.
    private func insert(_ element: E, at index: Int, val: T) {
        arr.insert(element, at: index)
        registerValue(val)
    }
    
    /// Remove the element at the  specified index with
    /// value of the monitored key specified.
    private func remove(at index: Int, val: T) {
        unregisterValue(val)
        arr.remove(at: index)
    }
    
    /// Remove the element at the  specified index.
    ///
    /// - Parameters:
    ///    - at: the index of the element to be removed.
    ///    - undoManager: an `UndoManager` that records and can redo changes.
    public func remove(at index: Int, undoManager: UndoManager? = nil) {
        let target = arr[index]
        let val = arr[index].value(forKey: key) as! T
        remove(at: index, val: val)
        
        undoManager?.registerUndo(withTarget: self) { mArr in
            mArr.insert(target, at: index, val: val)
        }
    }
    
    /// Swap the element at specified indices.
    ///
    /// - Parameters:
    ///    - firstIndex: index of one element to be swapped.
    ///    - secondIndex: index of the other element to be swapped.
    ///    - undoManager: the `UndoManager` used to record change.
    public func swap(_ i: Int, _ j: Int, undoManager: UndoManager? = nil) {
        arr.swapAt(i, j)
        
        // Store the reverse action.
        undoManager?.registerUndo(withTarget: self) { mArr in
            mArr.swap(j, i)
        }
    }
    
    /// Move elements at specified indices to specified index.
    ///
    /// Same as array's `move` method.
    public func move(
        fromOffsets source: IndexSet,
        toOffset destination: Int,
        undoManager: UndoManager? = nil
    ) {
        let oldArr = arr
        arr.move(fromOffsets: source, toOffset: destination)
        
        undoManager?.registerUndo(withTarget: self) { mArr in
            // if multiple source element, can't get back
            mArr.arr = oldArr
        }
    }
    
    /// Remove a list of elements from the array.
    ///
    /// - Parameters:
    ///    - offsets: the indices of elements to be removed.
    ///    - undoManager: the `UndoManager` used to record change.
    public func remove(
        atOffsets offsets: IndexSet, 
        undoManager: UndoManager? = nil
    ) {
        for index in offsets {
            remove(
                at: arr.index(arr.startIndex, offsetBy: index),
                undoManager: undoManager
            )
        }
    }
}
