//
//  GameScene.swift
//  Project11
//
//  Created by Daniel Sasse on 1/12/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabelNode: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabelNode.text = "Score: \(score)"
        }
    }
    
    var editLabelNode: SKLabelNode!
    var edittingMode: Bool = false {
        didSet {
            editLabelNode.text = edittingMode ? "Done" : "Edit"
        }
    }
    var minHeight: CGFloat!
    var ballsRemainingLabel: SKLabelNode!
    var ballsRemaining = 5 {
        didSet {
            ballsRemainingLabel.text = "Balls Remaining: \(ballsRemaining)"
        }
    }
    var resetLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        
        // replace whatevery graphic it covers, and position it behind the default layer
        background.blendMode = .replace
        background.zPosition = -2
        addChild(background)
        
        let dropZone = SKSpriteNode(
            color: (
                UIColor(
                    red: 0,
                    green: 1,
                    blue: 0,
                    alpha: 0.1)
               ),
            size: CGSize(width: background.size.width, height: background.size.height)
        )
        dropZone.position = CGPoint(x: background.position.x, y: background.position.y * 2)
        dropZone.zPosition = -1
        addChild(dropZone)
        
        minHeight = dropZone.position.y - (dropZone.size.height / 2)
        
        ballsRemainingLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsRemainingLabel.text = "Balls Remaining \(ballsRemaining)"
        ballsRemainingLabel.horizontalAlignmentMode = .right
        ballsRemainingLabel.position = CGPoint(x: 980, y: 680)
        addChild(ballsRemainingLabel)
        
        scoreLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabelNode.text = "Score: \(score)"
        scoreLabelNode.horizontalAlignmentMode = .right
        scoreLabelNode.position = CGPoint(x: 980, y: 630)
        addChild(scoreLabelNode)
        
        resetLabel = SKLabelNode(fontNamed: "Chalkduster")
        resetLabel.text = "Reset"
        resetLabel.position = CGPoint(x: 80, y: 680)
        addChild(resetLabel)
        
        editLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        editLabelNode.text = "Edit"
        editLabelNode.position = CGPoint(x: 80, y: 630)
        addChild(editLabelNode)
        

        
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
    
    func generateBall(at position: CGPoint){
        let ball = SKSpriteNode(imageNamed: getRandomBallImage())
        ball.name = "ball"
        ball.position = position
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        
        // record contacts for ALL collisions
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        
        ball.physicsBody?.restitution = 0.4
        
        ballsRemaining -= 1
        
        addChild(ball)
    }
    
    func getRandomBallImage() -> String {
        let ballImages = ["ballRed", "ballCyan", "ballBlue", "ballPurple", "ballGrey", "ballGreen", "ballYellow"]
        return ballImages.randomElement() ?? "ballRed"
    }
    
    func generateBlock(at position: CGPoint) {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let block = SKSpriteNode(
            color: UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1),
            size: size
        )
        block.name = "block"
        block.position = position
        block.zRotation = CGFloat.random(in: 0...3)
        block.physicsBody = SKPhysicsBody(rectangleOf: size)
        block.physicsBody?.isDynamic = false
        
        addChild(block)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        let touchedObjects = nodes(at: location)
        if touchedObjects.contains(editLabelNode){
            edittingMode.toggle()
        } else if touchedObjects.contains(resetLabel){
            resetGame()
        } else if edittingMode {
            generateBlock(at: location)
        } else if location.y > minHeight && ballsRemaining > 0 {
            generateBall(at: location)
        }
    }
    
    func resetGame() {
        ballsRemaining = 5
        score = 0
        edittingMode = false
        
        scene?.enumerateChildNodes(withName: "ball"){
            node, _ in
            node.removeFromParent()
        }
        scene?.enumerateChildNodes(withName: "block"){
            node, _ in
            node.removeFromParent()
        }
    }
    
    func collision(ball: SKNode?, object: SKNode?){
        guard let ball = ball else {return}
        guard let object = object else {return}
        if object.name == "good"{
            score += 1
            ballsRemaining += 1
            destroy(node: ball)
        } else if object.name == "bad"{
            score -= 1
            destroy(node: ball)
        } else if object.name == "block"{
            destroy(node: object)
        }
        // We dont care about ball -> <- ball collision
    }
    
    func destroy(node: SKNode){
        node.removeFromParent()
        
        if node.name == "ball"{
            if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
                fireParticles.position = node.position
                fireParticles.position.y -= node.frame.size.height / 2
                addChild(fireParticles)
            }
        }
            
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
