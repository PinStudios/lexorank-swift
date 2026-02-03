# LexoRank

A Swift implementation of LexoRank - a lexicographic ranking system that allows inserting items between any two existing items without reordering the entire collection.

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS-blue.svg)](https://developer.apple.com)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

## Overview

LexoRank generates sortable string values that can be positioned between any two existing values. This makes it ideal for:

- **Drag-and-drop reordering** in task lists, playlists, or any ordered collections
- **Real-time collaboration** where multiple users may reorder items simultaneously
- **Database ordering** without requiring full reindexing when items are moved

With a default configuration (baseScale 6, base36, step 8), a single bucket can hold approximately **260 million unique ranks**.

## Installation

### Swift Package Manager

Add LexoRank to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/PinStudios/lexorank-swift.git", from: "1.0.0")
]
```

Or add it through Xcode: File > Add Packages... and enter the repository URL.

## Usage

### Creating Your First Rank

```swift
import LexoRank

// Create the first rank in a list
let firstRank = try LexoRank.first()
print(firstRank.string) // "0|hzzzzz:"
```

### Inserting Items

```swift
// Get the next rank (for appending to end)
let secondRank = try firstRank.next()
print(secondRank.string) // "0|i00007:"

// Get the previous rank (for prepending to start)
let beforeFirst = try firstRank.prev()
print(beforeFirst.string) // "0|hzzzzr:"

// Insert between two existing ranks
let middle = try firstRank.between(other: secondRank)
print(middle.string) // "0|i00003:i"
```

### Storing and Restoring Ranks

```swift
let rank = try LexoRank.first()

// Convert to string for storage (e.g., in a database)
let rankString = rank.string // "0|hzzzzz:"

// Restore from string
let restoredRank = try LexoRank(rankString)
print(restoredRank.string) // "0|hzzzzz:"
```

### Comparing Ranks

```swift
let rankA = try LexoRank.first()     // "0|hzzzzz:"
let rankB = try rankA.next()         // "0|i00007:"

if try rankA < rankB {
    print("rankA comes before rankB") // This prints
}

// String comparison also works for sorting
print("hzzzzz:" < "i00007:") // true
```

### Working with Buckets

LexoRank uses buckets to support rebalancing when ranks become too long. Three buckets are available (`.bucket0`, `.bucket1`, `.bucket2`):

```swift
// Create a rank in a specific bucket
let rank = try LexoRank.first(bucket: .bucket1)
print(rank.string) // "1|hzzzzz:" (note the "1|" prefix)

// Access the bucket
print(rank.bucket) // bucket1

// Get the next bucket for rebalancing
let nextBucket = rank.bucket.nextBucket // .bucket2
```

### Configuration Options

```swift
// Custom base scale (6-10, default: 6)
// Higher values = more ranks before rebalancing needed
let rank6 = try LexoRank.first(baseScale: 6)
print(rank6.string) // "0|hzzzzz:" (6 chars before radix point)

let rank8 = try LexoRank.first(baseScale: 8)
print(rank8.string) // "0|hzzzzzzz:" (8 chars before radix point)

// Different number systems
let base10Rank = try LexoRank.first(numberSystemType: .base10)
print(base10Rank.string) // "0|500000:" (uses digits 0-9)

let base36Rank = try LexoRank.first(numberSystemType: .base36)
print(base36Rank.string) // "0|hzzzzz:" (uses 0-9, a-z - default)
```

## Real-World Example

Here's how you might use LexoRank in a todo list application:

```swift
struct TodoItem {
    let id: UUID
    var title: String
    var rank: String

    var lexoRank: LexoRank {
        get { try! LexoRank(rank) }
        set { rank = newValue.string }
    }
}

class TodoList {
    var items: [TodoItem] = []

    // Add item at the end
    func append(_ title: String) throws {
        let rank: LexoRank
        if let lastItem = items.last {
            rank = try lastItem.lexoRank.next()
        } else {
            rank = try LexoRank.first()
        }
        items.append(TodoItem(id: UUID(), title: title, rank: rank.string))
    }

    // Insert item at the beginning
    func prepend(_ title: String) throws {
        let rank: LexoRank
        if let firstItem = items.first {
            rank = try firstItem.lexoRank.prev()
        } else {
            rank = try LexoRank.first()
        }
        items.insert(TodoItem(id: UUID(), title: title, rank: rank.string), at: 0)
    }

    // Move item to a new position
    func move(from sourceIndex: Int, to destinationIndex: Int) throws {
        var item = items.remove(at: sourceIndex)

        let newRank: LexoRank
        if destinationIndex == 0 {
            newRank = try items[0].lexoRank.prev()
        } else if destinationIndex >= items.count {
            newRank = try items[items.count - 1].lexoRank.next()
        } else {
            newRank = try items[destinationIndex].lexoRank.between(
                other: items[destinationIndex - 1].lexoRank
            )
        }

        item.rank = newRank.string
        items.insert(item, at: destinationIndex)
    }
}
```

## Error Handling

LexoRank operations can throw `LexoRankError`:

```swift
do {
    let rank = try LexoRank("invalid")
} catch let error as LexoRankError {
    print(error.description)
}
```

Error types include:

- `bucketMissing` - Input string lacks bucket information
- `bucketOverflow` - No more ranks available in current bucket (rebalancing needed)
- `bucketMismatch` - Attempting to compare/combine ranks from different buckets
- `baseScaleMismatch` - Ranks have different base scales
- `numberSystemMismatch` - Ranks use different number systems
- `baseScaleOutOfRange` - Base scale must be between 6 and 10
- `decimalOverflow` - Operation resulted in overflow

## Rebalancing

If you exhaust ranks in a bucket (indicated by `bucketOverflow` error), perform a rebalancing operation:

```swift
func rebalance(items: inout [TodoItem]) throws {
    guard let firstItem = items.first else { return }

    let nextBucket = firstItem.lexoRank.bucket.nextBucket
    var rank = try LexoRank.first(bucket: nextBucket)

    for i in 0..<items.count {
        items[i].rank = rank.string
        rank = try rank.next()
    }
}
```

## Requirements

- Swift 5.0+
- iOS 10.0+ / macOS 10.11+ / tvOS 10.0+ / watchOS 3.0+

## License

LexoRank is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Credits

Created by Raimundas Sakalauskas.

Inspired by [Atlassian's LexoRank](https://www.youtube.com/watch?v=OjQv9xMoFbg) algorithm used in Jira.
