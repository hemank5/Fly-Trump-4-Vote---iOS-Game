//
//  GameScene.swift
//  Trump
//
//  Created by Hemank Narula on 3/14/16.
//  Copyright (c) 2016 Hemank Narula. All rights reserved.
//

import SpriteKit


struct PhysicsCategory {
    static let Trump : UInt32 = 0x1 << 1 // holds the properties and methods physics properties
    static let Ground : UInt32 = 0x1 << 2
    static let Pillar : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4  //for adding bitmask
}

class GameScene: SKScene , SKPhysicsContactDelegate {

    var Ground = SKSpriteNode() //create ground
    var Trump  = SKSpriteNode() //create character on the scene
    var btmPillar = SKNode() //creating pillar on the scene
    var moveAndRemove = SKAction() //moving and removing the pillar from scene
    var gameStarted = Bool()
    var score = Int() //for score
    let scoreLbl = SKLabelNode() //for showing score label on screen
    
    var died = Bool() //In order to make the character doesn't move if it collides we are adding this
    var restartBTN = SKSpriteNode()
    
    func restartScene()
    {
    self.removeAllChildren()
    self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    
    }
    func createScene()
    {
        
        //handle the delagate
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "9376507_orig")
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        //for setting the position of score label on the scene
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(score)"
        scoreLbl.fontName = "04b_19" //name of the font which we used for the game to display score
        scoreLbl.fontColor = UIColor.blue //font color which we used for displaying on the scene
        
        // setting the position of label , setting ordering
        scoreLbl.zPosition = 5
        //putting score label on screen
        self.addChild(scoreLbl)
        
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.5) //Size of the ground according to the size of the image it has to be set
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2) //middle of the scene, for adding pixels
        
        //For putting the physics properties on the character
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        //whether we are colliding or not
        Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        //Colliding with what?
        Ground.physicsBody?.collisionBitMask = PhysicsCategory.Trump
        //It test whether they have collided
        Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Trump
        
        Ground.physicsBody?.affectedByGravity = false
        //its an unmoving character when it hits by anything it doesn't gonna move
        Ground.physicsBody?.isDynamic = false
        //setting the placing on the scene
        Ground.zPosition = 3
        self.addChild(Ground) // in order to see the image on the scene
        
        Trump = SKSpriteNode(imageNamed: "donaldtrump")
        Trump.size = CGSize(width: 70, height: 80) //size of the character
        Trump.position = CGPoint(x: self.frame.width / 2 - Trump.frame.width, y: self.frame.height / 2 ) //position of character on the scene
        
        Trump.physicsBody = SKPhysicsBody(circleOfRadius: Trump.frame.height / 2)
        Trump.physicsBody?.categoryBitMask = PhysicsCategory.Trump
        //we are going to collide with both physics category
        Trump.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Pillar
        Trump.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Pillar | PhysicsCategory.Score
        
        // we want to have them affected by
        Trump.physicsBody?.affectedByGravity = false
        Trump.physicsBody?.isDynamic = true
        Trump.zPosition = 2
        
        self.addChild(Trump)

    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        createScene()
        
    }
    
    //in order to restart the game when we lose while playing, button created for that
    func createBTN(){
    
        restartBTN = SKSpriteNode(imageNamed: "Revote")
        restartBTN.size = CGSize(width: 97, height: 97)
        restartBTN.position = CGPoint(x: self.frame.width / 2, y : self.frame.height / 2) //setting the position on the scene
        restartBTN.zPosition = 6 //setting the ordering of the scene
        restartBTN.setScale(0)
        self.addChild(restartBTN) //for displaying on the scene
    
        restartBTN.run(SKAction.scale(to: 1.0, duration:0.3))
    }
    
    //what elements have collided with each other
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.Score && secondBody.categoryBitMask == PhysicsCategory.Trump  || firstBody.categoryBitMask == PhysicsCategory.Trump && secondBody.categoryBitMask == PhysicsCategory.Score {
            
            score += 1
            //for printing score on screen
            scoreLbl.text = "\(score)"
        }
        
         else if firstBody.categoryBitMask == PhysicsCategory.Trump && secondBody.categoryBitMask == PhysicsCategory.Pillar || firstBody.categoryBitMask == PhysicsCategory.Pillar && secondBody.categoryBitMask == PhysicsCategory.Trump
        {
            // for stopping the scene whenever the character touches any pillar
            enumerateChildNodes(withName: "btmPillar", using: ({(node, error) in
        node.speed = 0
                //in order to stop the incoming walls into the scene
                self.removeAllActions()
            }))
            if died == false
            {
                died = true
                createBTN()

            }
        }
        else if firstBody.categoryBitMask == PhysicsCategory.Trump && secondBody.categoryBitMask == PhysicsCategory.Ground || firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.Trump
        {
            // for stopping the scene whenever the character touches any pillar
            enumerateChildNodes(withName: "btmPillar", using: ({(node, error) in
                node.speed = 0
                //in order to stop the incoming walls into the scene
                self.removeAllActions()
            }))
            if died == false
            {
                died = true //to call the restart button when died
                createBTN()
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        if gameStarted == false{
            //createPillars()
            gameStarted = true
            
            Trump.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({
                () in
                
                self.createPillars()
            })

            let delay = SKAction.wait(forDuration: 2.0)
            let SpawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            //for moving the pipes
            let distance = CGFloat(self.frame.width + btmPillar.frame.width)
            let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.01 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            //according to the size of the character we have to set the velocity
            Trump.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
            Trump.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))

            
        
        }
            
        else
        {
            if died == true
            {
            
            }
            Trump.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
            Trump.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))

        }
        
        
        for touch in touches
        {
        let location = touch.location(in: self)
        
            if died == true
            {
             if restartBTN.contains(location)
             {
                restartScene()
            }
            }
            
        }
        
        
        
        }
    
    
    
    func createPillars(){
        
        // for calculating scores and displaying on the screen
        let scoreNode = SKSpriteNode(imageNamed: "vote2")
        
        scoreNode.size = CGSize(width: 80 , height: 80)
        scoreNode.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        // we dont want to affected
        scoreNode.physicsBody?.isDynamic = false
        //now adding bitmask
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
        // we are not colliding but we have to add
        scoreNode.physicsBody?.collisionBitMask = 0
        //in order to make contact with the things
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Trump
        scoreNode.color = SKColor.blue
        
        
        let btmPillar = SKSpriteNode(imageNamed: "Wall")
        
        btmPillar.name = "btmPillar"

        
        btmPillar.position = CGPoint(x: self.frame.width , y: self.frame.height / 2 - 350) //placing of wall on the ground from the surface

        btmPillar.setScale(0.5)
        
        btmPillar.physicsBody = SKPhysicsBody(rectangleOf: btmPillar.size)
        btmPillar.physicsBody?.categoryBitMask = PhysicsCategory.Pillar
        btmPillar.physicsBody?.collisionBitMask = PhysicsCategory.Trump
        btmPillar.physicsBody?.contactTestBitMask = PhysicsCategory.Trump
        btmPillar.physicsBody?.isDynamic = false
        btmPillar.physicsBody?.affectedByGravity = false
        
        btmPillar.zPosition = 1
        
        //calling random function to create walls on the scene with different position
        let randomPosition = CGFloat.random(min: -200, max: 200)
        btmPillar.position.y = btmPillar.position.y + randomPosition
        
        btmPillar.addChild(scoreNode)
        btmPillar.run(moveAndRemove)
        self.addChild(btmPillar)
        
    }
        
    
    
    //to move the background
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if gameStarted == true
        {
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    
                    //speed of background for repeated the background image
                    bg.position
                        = CGPoint(x: bg.position.x - 2, y : bg.position.y )
                    
                    //to make it infinite for the background
                    if bg.position.x <= -bg.size.width{
                        
                    bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                    }
                }))
            }
        
        }
    }
}
