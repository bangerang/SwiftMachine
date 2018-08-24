//
//  StateMachine.swift
//
//  Created by Johan Thorell on 2018-07-24.
//  Copyright © 2018 Johan Thorell. All rights reserved.
//

import Foundation

public protocol StateMachineDataSource {
    static var initialState: Self { get }
    static func shouldTransitionFrom(from: Self, to: Self) -> Bool
}
public protocol StateListener: class {
    func stateChanged<T: StateMachineDataSource>(for subject: Subject<T>)
}

public class Subject<State: StateMachineDataSource> {
    
    private var listeners: NSPointerArray = NSPointerArray.weakObjects()
    
    private var _state: State = State.initialState {
        didSet {
            listeners.compact()
            for i in 0..<listeners.count {
                guard let listener = listeners.object(at: i) as? StateListener else {
                    continue
                }
                listener.stateChanged(for: self)
            }
        }
    }
    
    var state: State {
        get {
            return _state
        }
        set {
            if (State.shouldTransitionFrom(from: _state, to: newValue)) {
                _state = newValue
            }
        }
    }
    
    func addListener<T: StateListener>(_ stateListener: T) {
        listeners.compact()
        listeners.addObject(stateListener)
        stateListener.stateChanged(for: self)
    }

}
