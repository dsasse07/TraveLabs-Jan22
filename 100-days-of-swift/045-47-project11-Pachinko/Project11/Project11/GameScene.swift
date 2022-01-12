//
//  GameScene.swift
//  Project11
//
//  Created by Daniel Sasse on 1/12/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        
        // replace whatevery graphic it covers, and position it behind the default layer
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        var isGoodSlot = true;
        for i in 0..<9 {
            let xPos = (1024 / 8) * i
            
            if i % 2 == 0 {
                generateStaticBouncer(at: CGPoint(x: xPos, y: 0))
            } else {
                generateSlot(at: CGPoint(x: xPos, y: 0), isGood: isGoodSlot)
                isGoodSlot = !isGoodSlot
            }
        }
                
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: background.size.width, height: background.size.height))
        //Set this scene as responsible for receiver and managing collision events
        physicsWorld.contactDelegate = self
        
    }
    
    func generateStaticBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        // Object is fixed but will react with other things
        bouncer.physicsBody?.isDynamic = false
        bouncer.zPosition = 1
        addChild(bouncer)
    }
    
    func generateSlot(at position: CGPoint, isGood: Bool) {
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
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.name = "ball"
        ball.position = location
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        
        // record contacts for ALL collisions
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        
        ball.physicsBody?.restitution = 0.4
        addChild(ball)
    }
    
    func collision(ball: SKNode?, object: SKNode?){
        guard let ball = ball else {return}
        guard let object = object else {return}
        if object.name == "good"{
            destroy(ball: ball)
        } else if object.name == "bad"{
            destroy(ball: ball)
        }
        // We dont care about ball -> <- ball collision
    }
    
    func destroy(ball: SKNode){
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball"{
            collision(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball"{
            collision(ball: nodeB, object: nodeA)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
}
