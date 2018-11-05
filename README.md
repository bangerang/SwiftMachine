# SwiftMachine
Manage state AND state transitions in a predictable and declarative way with SwiftMachine!


## Basic Example

Define your state and state machine:

```swift
enum PizzaState: StateMachineDataSource {

    case makingDough
    case addingTopping([Topping])
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

class Pizza: StateMachine<PizzaState> {

    private(set) var topping: [Topping] = []
    
    override var state: PizzaState {
        didSet {
            // Maybe we want to persist the topping
            if case .addingTopping(let topping) = state {
                self.topping = topping
                print(self.topping) // [salami, onion]
            }
        }
    }
}
```

Create a new state machine and modify its state:

```swift

let pizza = Pizza()

print(pizza.state) // .makingDough since we specified this as the initial state

pizza.state = .addingTopping([salami, onion]]

print(pizza.state) // .addingTopping

pizza.state = .eating

print(pizza.state) // still .addingTopping since transition between .addTopping and .eating is not allowed, you have the bake the pizza first!

pizza.state = .baking 

print(pizza.state) // .baking

pizza.state = .eating

print(pizza.state) // .eating

```


Listening for state changes:

```swift
class ViewController: UIViewController {
  
  let pizza = Pizza()
  
  override func viewDidLoad() {
     super.viewDidLoad()
     pizza.addListener(self) // No need to remove listener later since its stored as a weak reference
  }
  
  func updateUI() {
     switch pizza.state {
        case .makingDough:
            handleDoughUI()
        case .addingTopping(let toppings):
            handleToppingUI(toppings)
        case .baking:
            handleBakingUI()
        case .eating:
            handleEatingUI()
     }
  }
  
}
extension ViewController: StateListener {
    func stateChanged<T>(for stateMachine: StateMachine<T>) where T : StateMachineDataSource {
        switch stateMachine {
            updateUI()
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
