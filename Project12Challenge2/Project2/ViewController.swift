//
//  ViewController.swift
//  Project2
//
//  Created by Emily Widjaja on 6/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
// Other things I could do: add in a method to reset, i.e. a restart button. Instead of allowing negative scoring, just keep it at 0.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfQuestions = 0
    var highScore = -100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //add all potential countries in. WHy not do this when declaring the variable?
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        
        //edits CA Layer - gives options to modify appearance of views
        //set border of buttons
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        //colors CA is an earlier layer than where UIColor is declared, but can convert using the format - calling UIColor, specifiying color and then converting
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(showScore))
        
        //load old highscore (if never played, set to -100)
        let defaults = UserDefaults.standard
        if let savedHighScore = defaults.object(forKey: "highScore") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                highScore = try jsonDecoder.decode(Int.self, from: savedHighScore)
            } catch {
                print("No previous scores found.")
                highScore = -100
            }
        }
        
        askQuestion()
        
    }
    //method to show initial screen
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal) //.normal - standard state of the button
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
        title = "Your score is \(score). Guess: \(countries[correctAnswer].uppercased())"
        if numberOfQuestions == 15 {
            if score > highScore {
                let ac = UIAlertController(title: "New High Score!", message: "Congratulations! Your new high score is \(score)!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Return", style: .default, handler: nil))
                present(ac, animated: true)
            } else {
                let finalAlertController = UIAlertController(title: "Game over!", message: "Congratulations! Your final score is \(score)", preferredStyle: .alert)
                finalAlertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                present(finalAlertController, animated: true)
            }
            
            saveHighScore()
        }
        numberOfQuestions += 1
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        if sender.tag == correctAnswer {
            score += 1
            title = "Correct"
            message = "Correct! Your score is \(score)."
        }
        else {
            score -= 1
            title = "Wrong"
            message = "Wrong! That's the flag of \(countries[sender.tag].uppercased()). Your score is \(score)."
        }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion)) //handler is code executed when button tapped.
        present(ac, animated: true)
        
    }
    
    @objc func showScore() {
        let vc = UIActivityViewController(activityItems: ["Your score is \(String(score))"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    //saves if current score is greater than high score
    func saveHighScore() {
        let jsonEncoder = JSONEncoder()
        if highScore < score {
            //save highScore
            if let savedData = try? jsonEncoder.encode(score) {
                let defaults = UserDefaults.standard
                defaults.set(savedData, forKey: "highScore")
            } else {
                print("Failed to save score.")
            }
            print("Highest Score is: \(score). Previous highscore is: \(highScore)")
        }
    }
    
}

