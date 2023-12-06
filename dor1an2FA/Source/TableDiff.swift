//
//  TableDiff.swift
//  Authenticator
//
//  Copyright (c) 2015-2017 Authenticator authors
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

protocol Identifiable {
    func hasSameIdentity(as other: Self) -> Bool
}

enum Change<Index> {
    case insert(index: Index)
    case update(oldIndex: Index, newIndex: Index)
    case delete(index: Index)

    func map<Other>(_ transform: (Index) -> Other) -> Change<Other> {
        switch self {
        case let .insert(index):
            return .insert(index: transform(index))
        case let .update(oldIndex, newIndex):
            return .update(oldIndex: transform(oldIndex), newIndex: transform(newIndex))
        case let .delete(index):
            return .delete(index: transform(index))
        }
    }
}

func changesFrom<T: Identifiable>(_ oldItems: [T], to newItems: [T]) -> [Change<Int>] {
    return changes(
        from: oldItems,
        to: newItems,
        hasSameIdentity: { $0.hasSameIdentity(as: $1) },
        isEqual: { (_, _) in false }
    )
}

func changesFrom<T: Identifiable>(_ oldItems: [T], to newItems: [T]) -> [Change<Int>] where T: Equatable {
    return changes(
        from: oldItems,
        to: newItems,
        hasSameIdentity: { $0.hasSameIdentity(as: $1) },
        isEqual: ==
    )
}

// Diff algorithm from the Eugene Myers' paper "An O(ND) Difference Algorithm and Its Variations"
private func changes<T>(from oldItems: [T], to newItems: [T], hasSameIdentity: (T, T) -> Bool, isEqual: (T, T) -> Bool) -> [Change<Int>] {
    let MAX = oldItems.count + newItems.count
    guard MAX > 0 else {
        return []
    }
    let numDiagonals = (2 * MAX) + 1
    var V: [Int] = Array(repeating: 0, count: numDiagonals)
    var changesInDiagonal: [[Change<Int>]] = Array(repeating: [], count: numDiagonals)
    for D in 0...MAX {
        for k in stride(from: -D, through: D, by: 2) {
            var x: Int
            var changes: [Change<Int>]
            if D == 0 {
                x = 0
                changes = []
            } else
            if k == -D || (k != D && V[(k - 1) + MAX] < V[(k + 1) + MAX]) {
                x = V[(k + 1) + MAX]
                changes = changesInDiagonal[(k + 1) + MAX] + [.insert(index: (x - k) - 1)]
            } else {
                x = V[(k - 1) + MAX] + 1
                changes = changesInDiagonal[(k - 1) + MAX] + [.delete(index: x - 1)]
            }
            var y = x - k
            while x < oldItems.count && y < newItems.count
                && hasSameIdentity(oldItems[x], newItems[y]) {
                    if !isEqual(oldItems[x], newItems[y]) {
                        changes += [.update(oldIndex: x, newIndex: y)]
                    }
                    (x, y) = (x + 1, y + 1)
            }
            V[k + MAX] = x
            changesInDiagonal[k + MAX] = changes
            if x >= oldItems.count && y >= newItems.count {
                return changes
            }
        }
    }
    // With MAX = oldItems.count + newItems.count, a solution must be found by the above algorithm
    // but here's a delete-and-insert-everything fallback, just in case.
    return oldItems.indices.map({ .delete(index: $0) })
        + newItems.indices.map({ .insert(index: $0) })
}
