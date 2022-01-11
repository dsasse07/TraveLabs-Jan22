//
//  ViewController.swift
//  Project 8
//
//  Created by Daniel Sasse on 1/10/22.
//

import UIKit

class ViewController: UIViewController {
    var buttonsContainerView: UIView!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var matchedCount = 0;
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: \(score)"
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        // The lower this value, the more easily able to be stretched larged that its content. Default is 250
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess..."
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 24)
        currentAnswer.isUserInteractionEnabled = false
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        let clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        buttonsContainerView = UIView()
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cluesLabel)
        view.addSubview(scoreLabel)
        view.addSubview(answersLabel)
        view.addSubview(currentAnswer)
        view.addSubview(submitButton)
        view.addSubview(clearButton)
        view.addSubview(buttonsContainerView)
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.2),
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            clearButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: 320),
            buttonsContainerView.widthAnchor.constraint(equalToConstant: 750),
            buttonsContainerView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsContainerView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])

        let buttonWidth = 150
        let buttonheight = 80
        
        for row in 0..<4{
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("ABC", for: .normal)
                letterButton.addTarget(self, action: #selector(lettersTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * buttonWidth, y: row * buttonheight, width: buttonWidth, height: buttonheight)
                letterButton.frame = frame
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                buttonsContainerView?.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        loadLevel()
    }
    
    func loadLevel(){
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
                var clueString = ""
                var solutionString = ""
                var letterPieces = [String]()
                guard let level = self?.level else {return}
                
            if let levelFileUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
                    if let levelContents = try? String(contentsOf: levelFileUrl) {
                        var lines = levelContents.components(separatedBy: "\n")
                        lines.shuffle()
                        
                        for (index, line) in lines.enumerated() {
                            let parts = line.components(separatedBy: ": ")
                            let answer = parts[0]
                            let clue = parts[1]
                            
                            clueString += "\(index). \(clue)\n"
                            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                            self?.solutions.append(solutionWord)
                            solutionString += "\(solutionWord.count) letters\n"
                            
                            let bits = parts[0].components(separatedBy: "|")
                            letterPieces += bits
                        }
                    }
                }
            DispatchQueue.main.async {
                [weak self] in
                    self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                    self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
                    self?.letterButtons.shuffle()
                    
                    guard let buttonCount = self?.letterButtons.count else {return}
                    
                    if buttonCount == letterPieces.count {
                        for i in 0..<buttonCount {
                            self?.letterButtons[i].setTitle(letterPieces[i], for: .normal)
                        }
                    }
            }
        }
    }
    
    @objc func submitTapped(_ sender: UIButton){
        guard let guessText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: guessText){
            activatedButtons.removeAll()
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = guessText
            score += 1
            matchedCount += 1
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""
            
            if matchedCount == 7 { showWon() }
        } else {
            score -= 1
            showError()
        }
    }
    
    func showWon(){
        let ac = UIAlertController(title: "Well Done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Next", style: .default, handler: levelUp))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: resetUI))
        present(ac, animated: true, completion: nil)
    }
    
    func showError(){
        let ac = UIAlertController(title: "Whoops!", message: "That is incorrect", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Clear", style: .default))
        present(ac, animated: true, completion: clearGuess)
    }
                                   
    @objc func levelUp(action: UIAlertAction! = nil){
        level += 1
        resetUI()
    }
    
    @objc func resetUI(action: UIAlertAction! = nil){
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    @objc func lettersTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func clearTapped(_ sender: UIButton){
        clearGuess()
    }
    
    func clearGuess(){
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
}

