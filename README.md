# MasterKit
A Perfect Swift Framework. All the Extensions.


# ReferenceKit

Create a reference on any Swift value (Even structs!)

```swift
func testReference() {
    var foo = 1
    
    @Reference var this = &foo
    this += 1
    
    assert(foo != 1)
    assert(foo == 2)
}
```
