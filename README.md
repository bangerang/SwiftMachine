# SwiftMachine
Manage state AND state transitions in a predictable and declarative way with SwiftMachine!


## Basic Example

Define your state and subject:

```swift
enum PizzaState: StateMachineDataSource {

    case makingDough
    case addingTopping([Ingredients])
    case baking
    case eating
    
    static var initialState: PizzaState = .makingDough
    
    static func shouldTransition(from: PizzaState, to: PizzaState) -> Bool {
        switch (from, to) {
        case (.makingDough, addingTopping):
            return true
        case (.addingTopping, .baking):
            return true
        case (.baking, .eating):
            return true
        default:
            return false
        }
    }
}

class Pizza: Subject<PizzaState> {}
```

Create a new subject and modify its state:

```swift

let pizza = Pizza()

print(pizza.state) // .makingDough since we specified this as the initial state

pizza.state = .addTopping([salami, onion]]

print(pizza.state) // .addTopping

pizza.state = .eating

print(pizza.state) // still .addTopping since transition between .addTopping and .eat is not allowed, you have the bake the pizza first!

pizza.state = .baking 

print(pizza.state) // .baking

pizza.state = .eating

print(pizza.state) // .eating

```


Listening for state changes:

```swift
class ViewController {
  
  let pizza = Pizza()
  
  override func viewDidLoad() {
     super.viewDidLoad()
     pizza.addListener(self) // No need to remove listener later since its stored as a weak reference
  }
  
  func updateUI() {
     // Do stuff
  }
  
}
extension ViewController: StateListener {
    func stateChanged<T>(for subject: Subject<T>) where T : StateMachineDataSource {
        switch subject {
            case _ as Pizza:
            updateUI()
        default:
            assert(false)
        }
    }
}
```


## Installation

Carthage:
```
github "bangerang/SwiftMachine"
```
CocoaPods:
```
pod 'SwiftMachine'
```
## Credits

Thanks to [@jemmons](https://twitter.com/jemmons) for me inspiring me to build this library, I really recommend you to read his [blog](http://www.figure.ink/blog/2015/1/31/swift-state-machines-part-1) about State Machines in Swift.
