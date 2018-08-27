//
//  ViewController.swift
//  SwiftMachineExample
//
//  Created by Johan Thorell on 2018-08-24.
//  Copyright © 2018 Johan Thorell. All rights reserved.
//

import UIKit
import SwiftMachine


enum WeatherSeasonState: Int, StateMachineDataSource {
    
    case winter = 0
    case spring
    case summer
    case fall
    
    static var initialState: WeatherSeasonState = .winter
    
    static func shouldTransition(from: WeatherSeasonState, to: WeatherSeasonState) -> Bool {
        switch (from, to) {
        case (.winter, spring):
            return true
        case (.spring, .summer):
            return true
        case (.summer, .fall):
            return true
        case (.fall, .winter):
            return true
        default:
            return false
        }
    }

    
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    lazy var buttons: [UIButton] = {
        return [firstButton, secondButton, thirdButton, fourthButton]
    }()
    
    let weatherSeason = WeatherSeason()
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        let state = weatherSeason.state
        let newState = WeatherSeasonState(rawValue: sender.tag)!
        weatherSeason.state = newState
        
        if weatherSeason.state == state {
            let alert = UIAlertController(title: "Not allowed", message: "Transition between \(weatherSeason.state) and \(newState) is not allowed", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            show(alert, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherSeason.addListener(self)
    }
    
    func updateUI() {
        for button in buttons {
            if button.tag == weatherSeason.state.rawValue {
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .green
            }else {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .gray
            }
        }
    }

}
// MARK: - StateListener
extension ViewController: StateListener {
    func stateChanged<T>(for subject: Subject<T>) where T : StateMachineDataSource {
        switch subject {
            case _ as WeatherSeason:
            updateUI()
        default:
            assert(false)
        }
    }
}
