# MasterKit
A Perfect Swift Framework. All the Extensions.

MasterKit is a frameowork wrapper.

```swift
import MasterKit
```

 When you import it, it automatically imports these packages:
- ExpressibleEnum
- ReferenceKit
- RegexKit

You can also choose to import these packages individually.


# ReferenceKit

Create a reference on any Swift value (Even structs!)

```swift
import MasterKit
// or import ReferenceKit
func testReference() {
    var foo = 1
    
    @Reference var this = &foo
    this += 1
    
    assert(foo != 1)
    assert(foo == 2)
}
```
