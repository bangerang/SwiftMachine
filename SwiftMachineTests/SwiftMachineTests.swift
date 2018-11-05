//
//  SwiftMachineTests.swift
//  SwiftMachineTests
//
//  Created by Johan Thorell on 2018-08-23.
//  Copyright © 2018 Johan Thorell. All rights reserved.
//

import XCTest
@testable import SwiftMachine

class SwiftMachineTests: XCTestCase {
    
    // MARK: - Mocks
    var stateListenerMock: StateListenerMock!
    var stateMachine: StateMachineMock!
    
    class StateListenerMock: StateListener {

        var asyncExpectation: XCTestExpectation?
        
        func stateChanged<T>(for stateMachine: StateMachine<T>) where T : StateMachineDataSource {
            if let expectation = asyncExpectation {
                expectation.fulfill()
            }
        }
    }
    
    enum StateMock: StateMachineDataSource {
        
        case first
        case second
        case third
        
        static var initialState: SwiftMachineTests.StateMock = .first
        
        static func shouldTransition(from: SwiftMachineTests.StateMock, to: SwiftMachineTests.StateMock) -> Bool {
            switch (from, to) {
            case (.first, .second):
                return true
            case (.second, .third):
                return true
            case (.third, .first):
                return true
            default:
                print("transition between from \(from) to \(to) is not allowed")
                return false
            }
        }
    }
    
    class StateMachineMock: StateMachine<StateMock> {}
    
    // MARK: - Tests
    override func setUp() {
        super.setUp()
        stateListenerMock = StateListenerMock()
        stateMachine = StateMachineMock()
        stateMachine.addListener(stateListenerMock)
    }

    func testShouldBeAbleToGoFromFirstToSecond() {
        XCTAssert(stateMachine.state == .first)
        stateMachine.state = .second
        XCTAssert(stateMachine.state == .second)
    }
    
    func testShouldNotBeAllowedToFoFromFirstToThird() {
        XCTAssert(stateMachine.state == .first)
        stateMachine.state = .third
        XCTAssert(stateMachine.state == .first)
    }
    
    func testListenerShouldBeNotified() {
        XCTAssert(stateMachine.state == .first)
        let aExpectation = expectation(description: "Listener gets notified")
        stateListenerMock.asyncExpectation = aExpectation
        stateMachine.state = .second
        waitForExpectations(timeout: 0.2) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
        }
    }
}
