//
//  GameScene.swift
//  Consolidation7-ShootingGame
//
//  Created by Emily Widjaja on 21/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var objects = ["fish", "food-cherry", "leaf", "strawberry", "tomato"]
    var gameTimer: Timer!
    var endTimer: Timer!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    override func didMove(to view: SKView) {
        backgroundColor = .black
        let background = SKSpriteNode(imageNamed: "Shelves")
        background.size = CGSize(width: 1100, height: 768)
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 40
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 0, y: 20)
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(createObject), userInfo: nil, repeats: true)
        
        endTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(endGame), userInfo: nil, repeats: false)
    }
    
    //generation of objects
    @objc func createObject() {
        //select which row to create
        let rowNumber = Int.random(in: 1...3)
        var yCoordinate: CGFloat?
        switch rowNumber {
        case 1:
            yCoordinate = 200
        case 2:
            yCoordinate = 390
        case 3:
            yCoordinate = 580
        default:
            yCoordinate = 0
        }
        assert(yCoordinate != nil, "yCoordinate is nil")
        assert(yCoordinate! >= CGFloat(200) && yCoordinate! <= CGFloat(600), "yCoordinate not in correct range")
        
        //create the object
        guard let objectToCreate = objects.randomElement() else {return}
        
        let object = SKSpriteNode(imageNamed: objectToCreate)
        object.position = CGPoint(x: -50, y: yCoordinate!)
        object.size = CGSize(width: 100, height: 100)
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width/2)
        object.physicsBody?.velocity = CGVector(dx: 300, dy: 0)
        object.physicsBody?.angularVelocity = 0
        object.physicsBody?.linearDamping = 0
        
        if objectToCreate != "fish" {
            object.name = "good"
        } else {
            object.name = "bad"
        }
        addChild(object)
    }
    
    //make them disappear when tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "good" {
                node.removeFromParent()
                disappear(isGood: true, location: location)
            } else if node.name == "bad" {
                node.removeFromParent()
                disappear(isGood: false, location: location)
            }
        }
    }
    
    func disappear(isGood: Bool, location: CGPoint) {
        let smoke: SKEmitterNode?
        if isGood {
            smoke = SKEmitterNode(fileNamed: "correct.sks")
            score += 1
        } else {
            smoke = SKEmitterNode(fileNamed: "wrong.sks")
            score -= 1
        }
        assert(smoke != nil)
        
        guard let smokeEffect = smoke else {return}
        smokeEffect.position = location
        addChild(smokeEffect)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x > 1100 {
                node.removeFromParent()
            }
        }
    }
    
    @objc func endGame() {
        gameTimer.invalidate()
        
        guard let endGame = SKSpriteNode(fileNamed: "gameOver") else {return}
        endGame.position = CGPoint(x: 512, y: 374)
        addChild(endGame)
    }
    
}
