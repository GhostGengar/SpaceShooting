//
//  GameElements.swift
//  Space Game
//
//  Created by Luke Dinh on 4/10/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

struct CollisionBitMask {
    static let Alien:UInt32 = 0x00
    static let Photon:UInt32 = 0x01
    static let Player:UInt32 = 0x02
}

extension GameScene {
    
    func setUpStarField() {
        starField = SKEmitterNode(fileNamed: "Starfield")
        starField.position = CGPoint(x: self.size.width / 2, y: self.size.height + 100)
        starField.advanceSimulationTime(10)
        starField.zPosition = -1
        addChild(starField)
    }
    
    func setUpPlayer() {
        player = SKSpriteNode(imageNamed: "shuttle")
        player.position = CGPoint(x: self.size.width / 2, y: player.size.height + 20)
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player.physicsBody?.contactTestBitMask = CollisionBitMask.Alien
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        addChild(player)
    }
    
    func setUpLabels() {
        scoreLabel = SKLabelNode(text: "SCORE: 0")
        scoreLabel.position = CGPoint(x: self.size.width / 4, y: self.size.height - 100)
        scoreLabel.fontName = "AvenirNext-BoldItalic"
        scoreLabel.fontSize = 30
        score = 0
        addChild(scoreLabel)
        livesLabel = SKLabelNode(text: "LIFE: 3")
        livesLabel.position = CGPoint(x: 3 * self.size.width / 4, y: self.size.height - 100)
        livesLabel.fontName = "AvenirNext-BoldItalic"
        livesLabel.fontSize = 30
        lives = 2
        addChild(livesLabel)
    }
    
    func setUpMotion() {
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
    }
    
    func fireTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
    }
    
    func addEnemy() {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.size.width))
        let position = CGFloat(randomAlienPosition.nextInt())
        alien.position = CGPoint(x: position, y: self.size.height + alien.size.height)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.physicsBody?.categoryBitMask = CollisionBitMask.Alien
        alien.physicsBody?.contactTestBitMask = CollisionBitMask.Photon
        alien.physicsBody?.collisionBitMask = 0
        addChild(alien)
        let animationDuration:TimeInterval = 6 // May generate random duration to increase difficulty of the game.
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(y: -alien.size.height, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
    }
    
    func fireTorpedo() {
        run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        torpedoNode.physicsBody?.categoryBitMask = CollisionBitMask.Photon
        torpedoNode.physicsBody?.contactTestBitMask = CollisionBitMask.Alien
        torpedoNode.physicsBody?.contactTestBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        addChild(torpedoNode)
        let animationDuration:TimeInterval = 0.35
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(y: self.size.height + 10, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpedoNode.run(SKAction.sequence(actionArray))
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, alienNode: SKSpriteNode) {
        run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        addChild(explosion)
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        run(SKAction.wait(forDuration: 0.4)) { 
            explosion.removeFromParent()
        }
        score += 1
    }
    
    func alienDidCollideWithPlayer(alienNode: SKSpriteNode, playerNode: SKSpriteNode) {
        run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        addChild(explosion)
        run(SKAction.wait(forDuration: 0.4)) {
            explosion.removeFromParent()
        }
        if lives != 0 {
            
        }
    }
    
    func gameOver() {
        
    }
}
