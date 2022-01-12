//
//  ViewController.swift
//  Hangman
//
//  Created by Daniel Sasse on 1/11/22.
//

import UIKit

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[self.index(startIndex, offsetBy: offset)]
    }
}

class LetterGuess {
    var correctLetter: String
    var colNum: Int
    var correctWord: String {
        didSet{
            correctLetter = String(correctWord[colNum])
        }
    }
    var keyboardButtons: [String: UIButton]
    var letterButton: UIButton?
    var letter: String = "" {
        didSet {
            letterLabel.text = letter
            if letter.isEmpty {return}
            letterButton = keyboardButtons[letter]
        }
    }
    var isSubmitted = false {
        didSet {
            if letter == correctLetter {
                letterLabel.backgroundColor = .systemGreen
                adjustButtonColor(.systemGreen)
            } else if correctWord.contains(letter) {
                letterLabel.backgroundColor = .systemYellow
                adjustButtonColor(.systemYellow)
            } else if letter.isEmpty {
                letterLabel.backgroundColor = .systemBackground
            } else {
                letterLabel.backgroundColor = .lightGray
                adjustButtonColor(.lightGray)
            }
        }
    }
    var letterLabel = UILabel()
    
    init(col: Int, correctWord: String, keyboardButtons: [String: UIButton]){
        self.colNum = col
        self.correctLetter = String(correctWord[colNum])
        self.correctWord = correctWord
        self.keyboardButtons = keyboardButtons
        let xPos = (280 / 5 * col) + col * 5
    
        letterLabel.layer.borderWidth = 1
        letterLabel.layer.borderColor = UIColor.lightGray.cgColor
        letterLabel.frame = CGRect(
            x: xPos,
            y: 0,
            width: 50,
            height: 50)
        letterLabel.font = UIFont.systemFont(ofSize: 24)
        letterLabel.text = letter
        letterLabel.textAlignment = .center
    }
    
    func adjustButtonColor(_ color: UIColor ){
        if let letterButton = letterButton {
            switch color {
            case .systemGreen:
                letterButton.tintColor = color
            case .systemYellow:
                if letterButton.tintColor != .systemGreen {
                    letterButton.tintColor = .systemYellow
                }
            case .lightGray:
                if letterButton.tintColor != .systemGreen && letterButton.tintColor != .systemYellow{
                    letterButton.tintColor = .lightGray
                }
            default:
                return
            }
        }
    }
}


class Guess {
    var guessView = UIView()
    var letters = [LetterGuess]()
    var correctAnswer: String
    var keyboardButtons: [String: UIButton]
    
    init(parentView: UIView, guessNumber: Int, answer: String, keyboardButtons: [String:UIButton]){
        self.correctAnswer = answer
        self.keyboardButtons = keyboardButtons
        guessView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(guessView)
        
        NSLayoutConstraint.activate([
            guessView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: CGFloat(10 + (guessNumber * 60))),
            guessView.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            guessView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        for i in 0..<5 {
            let letterGuess = LetterGuess(
                col: i,
                correctWord: correctAnswer,
                keyboardButtons: keyboardButtons
            )
            guessView.addSubview(letterGuess.letterLabel)
            letters.append(letterGuess)
        }
        
    }
}

let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

class ViewController: UIViewController {
    var words: [String]? {
        didSet {
            wordCount = self.words?.count ?? 0
            correctWord = words?.randomElement() ?? "OOPSY"
        }
    }
    var wordCount = 0
    var correctWord = ""
    var currentGuessNumber = 0
    var currentLetterNumber = 0
    var guesses = [Guess]()
    var gameOver: Bool = false
    
    @IBOutlet var guessesView: UIView!
    var correctWordLabel: UILabel!
    
    // KeyBoard Buttons
    var keyboardButtons: [String: UIButton] = [:]
    @IBOutlet var qButton: UIButton!
    @IBOutlet var wButton: UIButton!
    @IBOutlet var eButton: UIButton!
    @IBOutlet var rButton: UIButton!
    @IBOutlet var tButton: UIButton!
    @IBOutlet var yButton: UIButton!
    @IBOutlet var uButton: UIButton!
    @IBOutlet var iButton: UIButton!
    @IBOutlet var oButton: UIButton!
    @IBOutlet var pButton: UIButton!
    
    @IBOutlet var aButton: UIButton!
    @IBOutlet var sButton: UIButton!
    @IBOutlet var dButton: UIButton!
    @IBOutlet var fButton: UIButton!
    @IBOutlet var gButton: UIButton!
    @IBOutlet var hButton: UIButton!
    @IBOutlet var jButton: UIButton!
    @IBOutlet var kButton: UIButton!
    @IBOutlet var lButton: UIButton!
    
    @IBOutlet var submitWordButton: UIButton!
    @IBOutlet var zButton: UIButton!
    @IBOutlet var xButton: UIButton!
    @IBOutlet var cButton: UIButton!
    @IBOutlet var vButton: UIButton!
    @IBOutlet var bButton: UIButton!
    @IBOutlet var nButton: UIButton!
    @IBOutlet var mButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    // Game Buttons
    @IBOutlet var newGameButton: UIButton!
    @IBOutlet var visibilityButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardButtons = [
            "a": aButton,
            "b": bButton,
            "c": cButton,
            "d": dButton,
            "e": eButton,
            "f": fButton,
            "g": gButton,
            "h": hButton,
            "i": iButton,
            "j": jButton,
            "k": kButton,
            "l": lButton,
            "m": mButton,
            "n": nButton,
            "o": oButton,
            "p": pButton,
            "q": qButton,
            "r": rButton,
            "s": sButton,
            "t": tButton,
            "u": uButton,
            "v": vButton,
            "w": wButton,
            "x": xButton,
            "y": yButton,
            "z": zButton,
            "del": deleteButton,
            "submit": submitWordButton
        ]
        
        correctWordLabel = UILabel()
        correctWordLabel.translatesAutoresizingMaskIntoConstraints = false
        correctWordLabel.font = UIFont.systemFont(ofSize: 24)
        correctWordLabel.isHidden = true
                
        view.addSubview(correctWordLabel)
        
        NSLayoutConstraint.activate([
            correctWordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            correctWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self, weak correctWordLabel] in
            self?.loadData()
            
            DispatchQueue.main.async {
                [weak self, weak correctWordLabel] in
                correctWordLabel?.text = self?.correctWord
                self?.buildGuessViews()
            }
        }
    }
    
    func buildGuessViews(){
        guesses = [
            Guess(parentView: guessesView, guessNumber: 0, answer: correctWord, keyboardButtons: keyboardButtons),
            Guess(parentView: guessesView, guessNumber: 1, answer: correctWord, keyboardButtons: keyboardButtons),
            Guess(parentView: guessesView, guessNumber: 2, answer: correctWord, keyboardButtons: keyboardButtons),
            Guess(parentView: guessesView, guessNumber: 3, answer: correctWord, keyboardButtons: keyboardButtons),
            Guess(parentView: guessesView, guessNumber: 4, answer: correctWord, keyboardButtons: keyboardButtons),
            Guess(parentView: guessesView, guessNumber: 5, answer: correctWord, keyboardButtons: keyboardButtons),
        ]
    }
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "sgb-words", withExtension: "txt") {
            if let words = try? String(contentsOf: url) {
                self.words = words.components(separatedBy: "\n")
            }
        }
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if gameOver {return}
        switch sender.tag {
        case 27:
            if currentLetterNumber != 5 {return}
            submitWord()
        case 26:
            if currentLetterNumber == 0 {return}
            deleteLetter()
        default:
            addLetter(alphabet[sender.tag])
        }
    }
    
    func submitWord(){
        var currentGuessWord = ""
        for letter in guesses[currentGuessNumber].letters {
            currentGuessWord += letter.letter
        }
        
        guard let words = words else {return}
        if !words.contains(currentGuessWord){
            displayInvalidWordAlert()
            return
        }

        for letter in guesses[currentGuessNumber].letters {
            letter.isSubmitted = true
        }
        
        if currentGuessWord == correctWord {
            endGame(condition: .win, score: currentGuessNumber)
        } else if currentGuessNumber == 5{
            endGame(condition: .lose, score: 0)
        }
        
        currentGuessNumber += 1
        currentLetterNumber = 0
    }
    
    func displayInvalidWordAlert(){
        let ac = UIAlertController(title: "Invalid Word", message: "This word is not found in the word list", preferredStyle: .alert)
        ac.addAction((UIAlertAction(title: "Ok", style: .default, handler: nil)))
        present(ac, animated: true, completion: nil)
    }
    
    func endGame(condition: GameEndCondition, score: Int){
        var title: String
        var message: String
        gameOver = true
        
        if condition == GameEndCondition.win {
            title = "You Did It!"
            message = "You scored \(score + 1)/6!"
        } else {
            title = "Sorry, not this time"
            message = "The correct word was: \(correctWord)"
        }
    
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play Again!", style: .default, handler: newGame))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func newGameTapped(_ sender: Any) {
        let ac = UIAlertController(title: "New Game?", message: "Are you sure you want to abandon the current game?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGame))
        present(ac, animated: true, completion: nil)
    }
    
    func newGame(action: UIAlertAction! = nil){
        var newWord = ""
        gameOver = false
        
        if let words = words {
            for _ in 0...100 {
                newWord = words.randomElement() ?? ""
                if newWord != correctWord && newWord != "" {
                    break
                }
            }
        }
        
        if newWord == correctWord || newWord == "" {
            print("error")
        } else {
            correctWord = newWord
            correctWordLabel.text = newWord
            currentGuessNumber = 0
            currentLetterNumber = 0
            for guess in guesses {
                guess.correctAnswer = correctWord
                for letter in guess.letters {
                    letter.letterLabel.backgroundColor = .systemBackground
                    letter.letterButton?.tintColor = .systemBlue
                    letter.letter = ""
                    letter.isSubmitted = false
                    letter.correctWord = correctWord
                }
            }
            for button in keyboardButtons.values {
                button.tintColor = .systemBlue
            }
        }
    }
    
    func deleteLetter(){
        currentLetterNumber -= 1
        guesses[currentGuessNumber].letters[currentLetterNumber].letter = ""
    }
    
    func addLetter(_ letter: String){
        var letterToChange: Int
        
        if currentLetterNumber < 5 {
            letterToChange = currentLetterNumber
            currentLetterNumber += 1
        } else {
            letterToChange = 4
        }
    
        guesses[currentGuessNumber].letters[letterToChange].letter = letter
    }
    
    
    @IBAction func toggleVisibility(_ sender: Any) {
        if correctWordLabel.isHidden {
            visibilityButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            visibilityButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        correctWordLabel.isHidden = !correctWordLabel.isHidden
    }
    
}

enum GameEndCondition {
    case win, lose
}
