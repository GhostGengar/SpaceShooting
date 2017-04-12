//
//  GameScene.swift
//  Space Game
//
//  Created by Luke Dinh on 4/10/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField:SKEmitterNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    var livesLabel:SKLabelNode!
    var lives:Int = 2 {
        didSet {
            livesLabel.text = "LIFE: \(lives + 1)"
        }
    }
    
    var timer:Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        setUpStarField()
        setUpPlayer()
        setUpLabels()
        setUpMotion()
        fireTimer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == CollisionBitMask.Alien && contact.bodyB.categoryBitMask == CollisionBitMask.Photon) || (contact.bodyA.categoryBitMask == CollisionBitMask.Photon && contact.bodyB.categoryBitMask == CollisionBitMask.Alien) {
            torpedoDidCollideWithAlien(torpedoNode: contact.bodyA.node as! SKSpriteNode, alienNode: contact.bodyB.node as! SKSpriteNode)
        } else if (contact.bodyA.categoryBitMask == CollisionBitMask.Alien && contact.bodyB.categoryBitMask == CollisionBitMask.Player) || (contact.bodyA.categoryBitMask == CollisionBitMask.Player && contact.bodyB.categoryBitMask == CollisionBitMask.Alien) {
            var playerNode:SKSpriteNode!
            var alienNode:SKSpriteNode!
            if contact.bodyA.categoryBitMask == CollisionBitMask.Alien {
                alienNode = contact.bodyA.node as! SKSpriteNode
                playerNode = contact.bodyB.node as! SKSpriteNode
            } else {
                alienNode = contact.bodyB.node as! SKSpriteNode
                playerNode = contact.bodyA.node as! SKSpriteNode
            }
        }
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 30
        if player.position.x < -20 {
            player.position.x = self.size.width + 20
        } else if player.position.x > self.size.width + 20 {
            player.position.x = -20
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
