//
//  GameScene.swift
//  Project14-WhackAPenguin
//
//  Created by Emily Widjaja on 16/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var numRounds = 0
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var popupTime = 0.85    //creates enemy once every 0.85 seconds
    
    override func didMove(to view: SKView) {
        //create UI
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)   //in middle of parent view
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 0, y: 0)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        
        
        //game setup - 1 second after starting, create first enemy
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else {continue} //node is the a charnode that is inside cropnode, which is in the whackSlot class. if it fails, it will be ignored and go to next tapped node
            if !whackSlot.isVisible {continue}
            if whackSlot.isHit {continue}   //if it has already been hit, continue
            whackSlot.hit()
            
            if node.name == "charFriend" {
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                //makes penguin look smaller when hit
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            let gameOverScore = SKLabelNode(fontNamed: "Chalkduster")
            gameOverScore.text = "Your final score is \(score)!"
            gameOverScore.fontSize = 44
            gameOverScore.horizontalAlignmentMode = .center
            gameOverScore.position = CGPoint(x: 512, y: 300)
            addChild(gameOverScore)
            
            run(SKAction.playSoundFileNamed("GameOver.m4a", waitForCompletion: false))
            return  //stops calling createEnemy
        }
        popupTime *= 0.991  //every enemy created slightly faster.
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        //sometimes show multiple penguins at a time
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)}
        
        //call itself after a random period of time
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
}
