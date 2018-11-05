//
//  StateMachine.swift
//
//  Created by Johan Thorell on 2018-07-24.
//  Copyright © 2018 Johan Thorell. All rights reserved.
//

import Foundation

public protocol StateMachineDataSource {
    static var initialState: Self { get }
    static func shouldTransition(from: Self, to: Self) -> Bool
}


public protocol StateListener: class {
    func stateChanged<T: StateMachineDataSource>(for subject: StateMachine<T>)
}


open class StateMachine<State: StateMachineDataSource> {
    
    private var listeners: NSPointerArray = NSPointerArray.weakObjects()
    
    private var _state: State = State.initialState {
        didSet {
            listeners.removeNilValues()
            for i in 0..<listeners.count {
                guard let listener = listeners.object(at: i) as? StateListener else {
                    continue
                }
                listener.stateChanged(for: self)
            }
        }
    }
    
    open var state: State {
        get {
            return _state
        }
        set {
            if (State.shouldTransition(from: _state, to: newValue)) {
                _state = newValue
            }
        }
    }
    
    public init() {}
    
    public func addListener<T: StateListener>(_ stateListener: T) {
        listeners.removeNilValues()
        listeners.addObject(stateListener)
        stateListener.stateChanged(for: self)
    }

}
