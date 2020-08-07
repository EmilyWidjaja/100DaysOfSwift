//
//  ViewController.swift
//  Project8
//
//  Created by Emily Widjaja on 10/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//  To do: Add mechanism to end the game if it is the last level w/ potential to restart

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"     //anytime score is changed, it is updated
        }
    }
    var level = 1
    var correct = 0
    
    override func loadView() {
        //main view is big white empty space
        view = UIView()
        view.backgroundColor = .white       //add more code later
        
        //score label
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false //make constraints by hand
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: \(score)"
        view.addSubview(scoreLabel)
        
        //CLues label - pinned to leading edge of screen, w/ 100pt margin. Takes 60% of screen.
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0        //wraps number of lines among however many lines it takes
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)       //allows it to be stretched mroe easily. sets UI vertical stretching priority to 1 (so most likely to be stretched)
        view.addSubview(cluesLabel)
        
        //answers label - takes up remaining 40% of remaining screen. height = clues label.
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        //Current Answer - where currently inputted answer will show. Not interactive.
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false          //inert label
        view.addSubview(currentAnswer)
        
        //submit button for current answer
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)    //sets code to be activated when button pressed in a .touchUpInside way.
        view.addSubview(submit)
        
        //clear button for current answer
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        //wraps our 20 buttons in a container view. Give the container view constraints
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        //activates all the constraints at once,. Instead of using .isActive = true
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),     //not to safe view - to a margin from the layout
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),    //multiplier taken into account first, then constant
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor), //center horizontally
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),        //pins right to edge
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),         //44pts is recommended for button size
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),      //same Y level as the submit button
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        //make buttons View
        let width = 150
        let height = 80
        for row in 0..<4 {  //from 0 up to excluding 4
            for column in 0..<5 {
                let letterButtton = UIButton(type: .system)
                letterButtton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButtton.setTitle("WWW", for: .normal)
                letterButtton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)    //automatically generates the x and y coordinates for each button
                letterButtton.frame = frame
                
                buttonsView.addSubview(letterButtton)
                letterButtons.append(letterButtton)
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }

    //MARK: - button methods
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {return}   //makes sure all buttons have titles
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)     //add to activated buttons array so we know it has been tapped.
        sender.isHidden = true  //cannot be tapped again
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else {return}
        if solutions.firstIndex(of: answerText) != nil {
            let solutionPosition = solutions.firstIndex(of: answerText)
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition!] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            correct += 1
            
            if correct % 7 == 0 {
                let ac = UIAlertController(title: "Well Done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Incorrect!", message: "Guess again!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Return", style: .default, handler: nil))
            present(ac,animated: true)
            score -= 1
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        performSelector(inBackground: #selector(loadLevel), with: nil)
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }

    //MARK: - Loading the level data
    var clueString = ""
    var solutionsString = ""
    var letterBits = [String]()
    
    
    @objc func loadLevel() {
        clueString = ""
        solutionsString = ""
        letterBits = []
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]       //thing on left
                    let clue = parts[1]        //thing on right
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionsString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        performSelector(onMainThread: #selector(updateLabels), with: nil, waitUntilDone: false)
        
    }
    
    @objc func updateLabels() {
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)        //trims whitespaces and characters from beginning and end of text. (in this case, know that there is a final line break)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        if letterButtons.count == letterBits.count {    //shd always have same number
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)  //goes through all the letter buttons and assigns a bit to them
            }
        }
    }
    
}

