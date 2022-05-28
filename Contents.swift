import UIKit

struct HashTable<Key: Hashable, Value> {
  private typealias Element = (key: Key, value: Value)
  private typealias Bucket = [Element]
  private var buckets: [Bucket]
  private (set) public var count = 0
  
  init(capacity: Int) {
    assert(capacity > 0)
    buckets = Array(repeating: [], count: capacity)
  }
  
  private func index(for key: Key) -> Int {
    return abs(key.hashValue % buckets.count)
  }
  
  public mutating func update(value: Value, for key: Key) -> Value? {
    let index = self.index(for: key)
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        let oldValue = element.value
        buckets[index][i].value = value
        return oldValue
      }
    }
    let element = Element(key, value)
    buckets[index].append(element)
    count += 1
    return nil
  }
  
  public func value(for key: Key) -> Value? {
    let index = self.index(for: key)
    for (_, element) in buckets[index].enumerated() {
      if element.key == key {
        return element.value
      }
    }
    return nil
  }
  
  public mutating func removeValue(for key: Key) -> Value? {
    let index = self.index(for: key)
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        let removedValue = element.value
        buckets[index].remove(at: i)
        count -= 1
        return removedValue
      }
    }
    return nil
  }
  
  subscript(_ key: Key) -> Value? {
    set {
      if let value = newValue {
        update(value: value, for: key)
      } else {
        removeValue(for: key)
      }
    } get {
      return value(for: key)
    }
  }
}

var jobSearch = HashTable<String, String>(capacity: 10)
jobSearch.update(value: "Applied", for: "Apple") // nil
jobSearch["Google"] = "Rejected" // Rejected
jobSearch["Zoc Doc"] = "Need to Apply"
jobSearch["Bloomberg"] = "Applied"
jobSearch["Fox"] = "Interview"
jobSearch.count // 2
print(jobSearch)
// HashTable<String, String>(buckets: [[], [(key: "Google", value: "Rejected")], [], [(key: "Zoc Doc", value: "Need to Apply")], [], [], [], [(key: "Apple", value: "Applied"), (key: "Fox", value: "Interview")], [], [(key: "Bloomberg", value: "Applied")]], count: 5)

jobSearch.update(value: "Offer", for: "Apple")
print(jobSearch)
// HashTable<String, String>(buckets: [[], [(key: "Google", value: "Rejected")], [], [(key: "Zoc Doc", value: "Need to Apply")], [], [], [], [(key: "Apple", value: "Offer"), (key: "Fox", value: "Interview")], [], [(key: "Bloomberg", value: "Applied")]], count: 5)
jobSearch["Fox"] = nil
jobSearch.removeValue(for: "Fox")
print(jobSearch)
// HashTable<String, String>(buckets: [[], [(key: "Google", value: "Rejected")], [], [(key: "Zoc Doc", value: "Need to Apply")], [], [], [], [(key: "Apple", value: "Offer")], [], [(key: "Bloomberg", value: "Applied")]], count: 5)
