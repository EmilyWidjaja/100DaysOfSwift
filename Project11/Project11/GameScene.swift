//
//  GameScene.swift
//  Project11
//
//  Created by Emily Widjaja on 14/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var ballCount = 5 {
        didSet {
            ballCountLabel.text = "Balls remaining: \(ballCount)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    var ballCountLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace     //draw ignoring transparencies, no alpha (not transparent at all)
        background.zPosition = -1   //put in the background of everything
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        ballCountLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballCountLabel.text = "Balls remaining: 5"
        ballCountLabel.horizontalAlignmentMode = .right
        ballCountLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballCountLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)    //gives a physics body to screen
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false  //will not be moved by physics but can collide with other objects
        addChild(bouncer)
        
    }
    
    // called when touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}   //makes sure get one touch
        let location = touch.location(in: self)
        let objects = nodes(at: location)    //gets the nodes at the location (did they touch edit or want to make a ball?)
        if objects.contains(editLabel) {
            editingMode.toggle()        //editingMode = !editingMode
        } else {
            if editingMode {
                //create a box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                addChild(box)
            } else {
                if ballCount > 0 {
                    //generate ball name
                    let ballColours = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow"]  //hardcoded - try generating from assets
                    let ballColour = ballColours[Int.random(in: 0..<ballColours.count)]
                    //generate ball
                    let ball = SKSpriteNode(imageNamed: "ball\(ballColour)")
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
                    ball.physicsBody?.restitution = 0.4 //restitution - bounciness
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0 //colissionbitmask what shd they bounce to, by default set to every physics body. contacttestbitmask - which bounces do you want to know about? '?? 0' - nil coalescing since there may not be a physics body
                    ball.position = CGPoint(x: location.x, y: 700)
                    ball.name = "ball"
                    addChild(ball)
                    ballCount -= 1
                }
            }
            
        }
        
      /*  // when tapped, creates box
        let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) //give it a physics body matching size of box
        box.position = location
        addChild(box)   */
        
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            ballCount += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "box" {
            destroy(ball: object)
        }
     }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {  //SKEmitterNode creates high performance animations?
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()         //removes ball
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
}
