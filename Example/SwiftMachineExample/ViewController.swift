//
//  ViewController.swift
//  SwiftMachineExample
//
//  Created by Johan Thorell on 2018-08-24.
//  Copyright © 2018 Johan Thorell. All rights reserved.
//

import UIKit
import SwiftMachine

enum PizzaState: String, StateMachineDataSource {
    case capricciosa
    case azteka
    case hawaii
    
    static var initialState: PizzaState = .capricciosa
    
    static func shouldTransitionFrom(from: PizzaState, to: PizzaState) -> Bool {
        switch (from, to) {
        case (.capricciosa, .azteka),
             (.capricciosa, hawaii):
            return true
        case (.azteka, .hawaii),
             (.azteka, .capricciosa):
            return true
        case (.hawaii, .azteka):
            return true
        default:
            return false
        }
    }
    var tag: Int {
        switch self {
        case .capricciosa:
            return 0
        case .azteka:
            return 1
        case .hawaii:
            return 2
        }
    }
    
}

class PizzaSubject: Subject<PizzaState> {}

class ViewController: UIViewController {

    @IBOutlet weak var capricciosaLabel: UILabel!
    @IBOutlet weak var aztekaLabel: UILabel!
    @IBOutlet weak var hawaiiLabel: UILabel!
    
    lazy var labels: [UILabel] = {
        return [capricciosaLabel, aztekaLabel, hawaiiLabel]
    }()
    
    var pizzaSubject = PizzaSubject()
    var stateArray: [PizzaState] = [.capricciosa, .azteka, .hawaii, .azteka, .hawaii, .azteka]
    var currentIndex: Int = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        capricciosaLabel.tag = PizzaState.capricciosa.tag
        capricciosaLabel.text = PizzaState.capricciosa.rawValue
        
        aztekaLabel.tag = PizzaState.azteka.tag
        aztekaLabel.text = PizzaState.azteka.rawValue
        
        hawaiiLabel.tag = PizzaState.hawaii.tag
        hawaiiLabel.text = PizzaState.hawaii.rawValue
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: (#selector(nextLabel)), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    
    @objc func nextLabel() {
        if currentIndex < stateArray.count {
            showView(with: stateArray[currentIndex])
            currentIndex = currentIndex + 1
        }else {
            currentIndex = 0
        }
    }
    func hideAllViews() {
        labels.forEach{ $0.isHidden = true }
    }
    func showView(with state: PizzaState) {
        hideAllViews()
        let view = labels.first(where: { $0.tag == state.tag })
        view?.isHidden = false
        view?.alpha = 0
        UIView.animate(withDuration: 0.4) {
            view?.alpha = 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

