//
//  GameScene.swift
//  Project17(Timers)
//
//  Created by Emily Widjaja on 21/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    var timeInterval: Double = 1.0
    var enemiesMade = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        //sets up view
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10) //when screen starts up, particles not yet generated, so will be black screen. advances simualtions
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size) //makes a physics body by drawing around player's texture at current size
        player.physicsBody?.contactTestBitMask = 1 // care about other things that it collides with
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self //tells us when contact is made
        
        //sets up gameplay
        timeInterval = 1.0
        perform(#selector(createTimer), with: nil, afterDelay: 1)   //Challenge 2
    }
    
    @objc func createTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        enemiesMade += 1
        
        //randomly choose enemy
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        //create new sprite node
        let sprite = SKSpriteNode(imageNamed: enemy)
        
        //create motion & position
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1 //let it collide with the player
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)    //constant velocity
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0       //default is usually higher
        sprite.physicsBody?.angularDamping = 0
        
        if enemiesMade >= 20 {
            print("enemies increased!")
            gameTimer?.invalidate()
            timeInterval -= 0.1
            enemiesMade = 0
            createTimer()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // removes nodes once off-screen
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    
    //MARK: Touching methods - still some bugs CG REct not updating properly
    var endTouch: CGPoint?
    var startTouch: CGPoint?
    var startLocation: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        startTouch = touch.location(in: self)
        print("startTouch: \(startTouch!)")
        startLocation = player.position
    }
    
    //called when exisitng touch changes position
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        let allowedStart = CGRect(x: startLocation!.x - 50, y: startLocation!.y - 50, width: 100.0, height: 100.0)
        guard let startingTouch = startTouch else {return}
        print("Starting Touch: \(startingTouch)")
        print(allowedStart.contains(startingTouch))
        if allowedStart.contains(startingTouch) || endTouch == nil {
            print("allowed!")
            //clamps position
            if location.y < 100 {
                location.y = 100
            } else if location.y > 668 {
                location.y = 668
            }
            player.position = location
        } else {
            print("not allowed!")
            player.position.x = endTouch!.x - startTouch!.x + location.x
            player.position.y = endTouch!.y - startTouch!.y + location.y
            if player.position.y < 100 {
                       player.position.y = 100
                   } else if player.position.y > 668 {
                       player.position.y = 668
                   }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        endTouch = touch.location(in: self)
        print("EndTouch: \(endTouch!)")
    }
    
    //MARK: Game ending
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        gameTimer?.invalidate()             //challenge 3
    }
    
    
}
