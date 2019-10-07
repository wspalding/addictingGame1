//
//  GameScene.swift
//  RainBowWalls2
//
//  Created by William Spalding on 1/27/17.
//  Copyright © 2017 William Spalding. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var isGameOver = true
    var addWallOnTouch = false
    let player = SKSpriteNode(imageNamed: "dot3")
    var wallList = [SKSpriteNode]()
    let rainbow_images = ["testWallRed", "testWallBlue","testWallGreen","testWallYellow","testWallPink","testWallPurple","testWallDarkPurple","testWallOrange","testWallTeal","testWallLightBlue", "testWallGreen2"]
    var texture = "rainbow"
    //var playerImage = "dot3"
    var wallImage : String
    {
        var currentTexture : [String]
        switch texture {
        case "rainbow":
            currentTexture = rainbow_images
            break
        default:
            currentTexture = rainbow_images
            break
        }
        
        let randomindex = Int(arc4random()) % currentTexture.count
        return currentTexture[randomindex]
    }
    let remove = SKAction.removeFromParent()
    let waitThenRemove = SKAction.sequence([ SKAction.wait(forDuration: 5),
                                             SKAction.removeFromParent()])
    var difficulty = 1.0
    struct PhysicsCategory
    {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let player    : UInt32 = 0b1       // 1
        static let wall      : UInt32 = 0b10      // 2
    }
    
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        player.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.All
        player.physicsBody?.collisionBitMask = PhysicsCategory.All
        addChild(player)
    }
    
    func gameOver()
    {
        clearWalls()
        isGameOver = true
        player.removeFromParent()
        player.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.All
        player.physicsBody?.collisionBitMask = PhysicsCategory.All
        addChild(player)

    }
    //MARK: touch functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(!isGameOver && addWallOnTouch)
        {
            guard let touch = touches.first else {return}
            let touchLocation = touch.location(in: self)
            spawnStaticWall(at: touchLocation)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(!isGameOver)
        {
            guard let touch = touches.first else {return}
            let touchLocation = touch.location(in: self)
            player.physicsBody?.velocity = CGVector(dx: touchLocation.x - player.position.x,
                                                dy: touchLocation.y - player.position.y)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    
    }
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        //print("contact")
        if (contact.bodyA.categoryBitMask & contact.bodyB.categoryBitMask == 0 )
        {
            gameOver()
        }
    }
    
    
    //var attackDirection = Double(Int(arc4random()) % 4) + 1
    var currentAttackDirection = Double(Int(arc4random()) % 4) + 1
    var attackPosition : CGPoint
    {
        switch currentAttackDirection
        {
        case 1:
            return CGPoint(x: player.position.x, y: 11) //top
        case 2:
            return CGPoint(x: player.position.x, y: frame.size.height - 11) //bottom
        case 3:
            return CGPoint(x: 11, y: player.position.y) //left
        default:
            return CGPoint(x: frame.size.width - 11, y: player.position.y) //right
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
        for wall in wallList
        {
            if(!frame.intersects(wall.frame))
            {
                wall.removeFromParent()
            }
        }
        if(!frame.intersects(player.frame))
        {
            gameOver()
        }
        if(!isGameOver)
        {
            let timeToAttack = (Double(Int(currentTime * difficulty) % 4) + 1)
            //print("time ", time )
            //print("direction ", currentAttackDirection)
            if(timeToAttack == currentAttackDirection)
            {
                spawnAttackWall(atPoint: attackPosition, towardsSpriteNode: player)
                currentAttackDirection = Double(Int(arc4random()) % 4) + 1
            }
        }
    }
    
    func spawnAttackWall(atPoint: CGPoint, towardsSpriteNode: SKSpriteNode)
    {
        let newWall = SKSpriteNode(imageNamed: wallImage)
        newWall.position = atPoint
        wallList.append(newWall)
        newWall.physicsBody = SKPhysicsBody(rectangleOf: newWall.size)
        newWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        newWall.physicsBody?.contactTestBitMask = PhysicsCategory.wall
        newWall.physicsBody?.collisionBitMask = PhysicsCategory.All
        addChild(newWall)
        newWall.physicsBody?.velocity = CGVector(dx: towardsSpriteNode.position.x - newWall.position.x,
                                                 dy: towardsSpriteNode.position.y - newWall.position.y)
    }
    func spawnStaticWall(at: CGPoint)
    {
        let wall = SKSpriteNode(imageNamed: wallImage)
        wallList.append(wall)
        wall.position = at
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        wall.physicsBody?.contactTestBitMask = PhysicsCategory.wall
        wall.physicsBody?.collisionBitMask = PhysicsCategory.All
        addChild(wall)
        wall.run(waitThenRemove)
        
    }

    func clearWalls()
    {
        for wall in wallList
        {
            wall.removeFromParent()
        }
    }
    
    
}
