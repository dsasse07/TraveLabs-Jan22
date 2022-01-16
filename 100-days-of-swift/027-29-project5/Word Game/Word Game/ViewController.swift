//
//  ViewController.swift
//  Word Game
//
//  Created by Daniel Sasse on 1/6/22.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var score = 0 {
        didSet {
            scoreButton.title = "\(score)"
        }
    }
    var scoreButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreButton = UIBarButtonItem(title: "\(score)", style: .plain, target: self, action: #selector(displayScore))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame)),
            scoreButton
            ,
            
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForWord))
        
        if let pathUrl = Bundle.main.url(forResource: "eightLetterWords", withExtension: "txt") {
            if let startWords = try? String(contentsOf: pathUrl){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        score = 0
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        var cellContents = cell.defaultContentConfiguration()
        cellContents.text = usedWords[indexPath.row]
        cell.contentConfiguration = cellContents
        return cell
    }
    
    @objc func displayScore(){
        let alertController = UIAlertController(title: "Score", message: "Your current score is \(score)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        alertController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func promptForWord(){
        let ac = UIAlertController(title: "Enter Word", message: nil, preferredStyle: .alert)
        // Creates a text field in the aler
        ac.addTextField(configurationHandler: nil)
        
        //Create the submit action used a trailing closure syntax for an anonymous closure instead of passing in the closure by name
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            // Specifies the INPUT into the closure
            // weak self and weak ac means that those two variables will not be retained in memory once viewController ends
            // We know that these will still exist when this method runs, but to confirm that for Swift, we must unwrap them.
            [weak self, weak ac] action in
                // Make sure we can get to the text and that it exists, otherwise return
                guard let answer = ac?.textFields?[0].text else {return}
                self?.submitWord(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
    }
    
    func submitWord(_ answer: String){
        let preparedWord = prepareWord(answer)
        if isPossibleWord(preparedWord) {
            if isNewWord(preparedWord) {
                if isValidWord(preparedWord){
                    usedWords.insert(preparedWord, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    score += 1
                    navigationItem.leftBarButtonItem?.title = "\(score)"
                    tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                    invalidWordAlert(message: "Invalid Word")
                }
            } else {
                invalidWordAlert(message: "This word has already been used")
            }
        } else {
            invalidWordAlert(message: "This is not a possible entry")
        }
    }
    
    func invalidWordAlert(message: String) {
        let ac = UIAlertController(title: "Whoops!", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    private func prepareWord(_ word: String) -> String {
        return word.lowercased()
    }
    
    private func isPossibleWord(_ word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        for char in word {
            if let position = tempWord.firstIndex(of: char){
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    private func isNewWord(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isValidWord(_ word: String) -> Bool {
        // Spell Checker component
        // We can use this to see if the word is a real word
        let checker = UITextChecker()
        // Need to convert our Swift string to a ObjC string for UITextChecker
        // Ex: é is stored as one char in Swift, but multiple characters in older encoding like ObjC
        let range = NSRange(location: 0, length: word.utf16.count)
        // This spell check returns a range of where the mispelling occurs
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        // We only want to know if there are no mispellings. NSRange is a OLDER codebase, prior to optionals
        return misspelledRange.location == NSNotFound
            
    }

}

