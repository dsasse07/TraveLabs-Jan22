//
//  ViewController.swift
//  Project 2
//
//  Created by Daniel Sasse on 1/4/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer: Int = 0
    var playerScore: Int = 0 {
        didSet {
            navigationItem.prompt = "Current Score: \(playerScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "uk", "us"]
        navigationItem.prompt = "Current Score: \(playerScore)"
        setButtonsStyles(buttons: button1, button2, button3)
        
        askQuestion()
    }
    
    func setButtonsStyles(buttons: UIButton...){
        for button in buttons {
            // Sets the border on the button CALayer programatically
            button.layer.borderWidth = 1
            // CALayer lives below UILayer, so it doesnt know about UILayer properties like UIColor. Instead it only knows CGColor.
            // However, since UILayer is above the CALayer, UILayer(the button) knows how to convert to CALayer props
            button.layer.borderColor = UIColor.lightGray.cgColor
            // Removes gap from button content to border
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }
    
    func askQuestion(action: UIAlertAction! = nil){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }

    // Wire up actions by dragging from Interface builder
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            playerScore += 1
        } else {
            title = "Wrong"
            playerScore -= 1
        }
        
        // Create an alert modal to display the result, add an action button to it, and then present the alert
        let alertController = UIAlertController(title: title, message: "Your score is \(playerScore)", preferredStyle: .alert )
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(alertController, animated: true)
    }
    
}

