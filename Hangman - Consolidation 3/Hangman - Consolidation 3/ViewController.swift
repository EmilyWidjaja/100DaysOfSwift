//
//  ViewController.swift
//  Hangman - Consolidation 3
//
//  Created by Emily Widjaja on 13/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var words = [String]()
    var wordToGuess = ""
    var guessedWord = "" {
        didSet{
            guessedWordLabel.text = guessedWord
        }
    }
    var lives: Int? {
        didSet {
            livesLabel.text = "Lives: \(lives!)"
        }
    }
    var guessedLetters = "" {
        didSet {
            guessedLettersLabel.text = guessedLetters
        }
    }
    
    
    @IBOutlet weak var guessedWordLabel: UILabel!
    @IBOutlet weak var submissionText: UITextField!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var actualSubmitButton: UIButton!
    @IBOutlet weak var guessedLettersLabel: UILabel!
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        setUpLevel()
    }
    
    
    //submitButton is too long - split it up into smaller functions to make it easier to debug and to read
    @IBAction func submitButton(_ sender: UIButton) {
        guard let answerText = submissionText.text?.lowercased() else {return}
        if answerText.count != 1 {
            let ac = UIAlertController(title: "Guess again!", message: "You can only guess one letter at a time.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Return", style: .default))
            present(ac, animated: true)
            return
        }
        
        //checks whether already guessed
        if guessedLetters.contains(answerText) == true {
            let ac = UIAlertController(title: "Guess again!", message: "You've already guessed this letter!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Return", style: .default))
            present(ac, animated: true)
            return
        }
        
        //checks & replaces guessed letter in guessed word if correct
        var newGuessedWord = ""
        guessedLetters += ", \(answerText)"
        guessedLetters = guessedLetters.trimmingCharacters(in: .whitespaces)
        guessedLetters = guessedLetters.trimmingCharacters(in: .punctuationCharacters)
        submissionText.text = ""
        if wordToGuess.contains(answerText) {
            for (index, letter) in wordToGuess.enumerated() {
                let charAtIndex = guessedWord[guessedWord.index(guessedWord.startIndex, offsetBy: index)]
                if charAtIndex != "X" {     //has it already been guessed
                    newGuessedWord += String(charAtIndex)
                } else {
                    if answerText == String(letter) {
                        newGuessedWord += String(letter)
                    } else {
                        newGuessedWord += "X"
                    }
                }
            }
            guessedWord = newGuessedWord
            checkGuessed()
        } else {
            lives? -= 1
            let checkedLives = checkLives()
            if checkedLives == true {
                let ac = UIAlertController(title: "Wrong guess!", message: "Your letter is not in this word!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default))
                present(ac, animated: true)
            }
            else {
                let ac = UIAlertController(title: "Game Over!" , message: "You have no remaining lives. Play again?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Return", style: .default))
                present(ac, animated: true)
                endLevel()
            }
        }
    }
    
    @IBAction func clearButton(_ sender: Any) {
        submissionText.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //load words
        if let startWordsURL = Bundle.main.url(forResource: "common-nouns", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                words = startWords.components(separatedBy: "\n")
            }
        }
        
        if words.isEmpty {
            words = ["ability", "academy", "affairs", "alcohol", "extreme", "factors", "fashion"]
            print("Could not find!")
        }
        
        setUpLevel()
    }

    func setUpLevel() {
        //set up random word
        wordToGuess = words.randomElement()!
        print(wordToGuess)
        
        guessedWord = ""
        for letter in wordToGuess {
            guessedWord += "X"
        }
        //guessedWordLabel.text = guessedWord
        lives = guessedWord.count
        actualSubmitButton.isEnabled = true
        guessedLetters = ""
    }

    func checkLives() -> Bool {
        if lives! <= 0 {
            return false
        } else {
            return true
        }
    }
    
    func checkGuessed() {
        if guessedWord == wordToGuess {
            let ac = UIAlertController(title: "You Won!", message: "You've correctly guessed the word! Hit restart to play again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Return", style: .default))
            present(ac, animated: true) //need to deactivate all buttons except for restart
            endLevel()
        }
    }
    
    func endLevel() {
        guessedWordLabel.text = wordToGuess
        actualSubmitButton.isEnabled = false
    }
}

