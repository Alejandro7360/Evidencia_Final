//
//  GamePlayScenes.swift
//  Just Another Runner
//
//  Created by Alumnoids on 24/04/18.
//  Copyright © 2018 Alumnoids. All rights reserved.
//

import SpriteKit

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    var player = Player()
    var puedeSaltar = false
    var obstacles = [SKSpriteNode]()
    var spawnkill = Timer()
    var counterkill = Timer()
    var movePlayer = false;
    var playerOnObstacle = false;
    var estaVIVO = false
    override func didMove(to view: SKView) {
        initialize()
    }
    override func update(_ currentTime: TimeInterval) {
        moverBGandG()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if puedeSaltar {
            puedeSaltar = false
            player.salto()
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        var puerco1 = SKPhysicsBody()
        var puerco2 = SKPhysicsBody()
        if contact.bodyA.node?.name == "Player"{
            puerco1 = contact.bodyA
            puerco2 = contact.bodyB
        } else {
            puerco1 = contact.bodyB
            puerco2 = contact.bodyA
        }
        if puerco1.node?.name == "Player" && puerco2.node?.name == "Ground"{
            puedeSaltar = true
        }
        if puerco1.node?.name == "Player" && puerco2.node?.name == "Obstacle" {
            if !puedeSaltar {
                movePlayer = true;
                playerOnObstacle = true;
            }
        }
        if puerco1.node?.name == "Player" && puerco2.node?.name == "Cocktus" {
            print("you dead son")
        }
    }
    func initialize() {
        physicsWorld.contactDelegate = self
        crearPlayer()
        crearFondo()
        crearSuelo()
        crearObstaCULO()
        spawnkill = Timer.scheduledTimer(timeInterval: TimeInterval(randomBetweenNumbers(2.5, secondNumber: 6)), target: self, selector: #selector(GamePlayScene.aparescanObstaCULOS), userInfo: nil, repeats: true);
    }
    func crearPlayer() {
        player = Player(imageNamed: "Player 1")
        player.initialize()
        player.position = CGPoint(x: -10, y: 20)
        self.addChild(player)
    }
    func crearFondo() {
        for i in 0...2 {
            let bg: SKSpriteNode = SKSpriteNode(imageNamed: "BG")
            bg.name = "BG"
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0.5)
            bg.zPosition = 0
            self.addChild(bg);
        }
    }
    func crearSuelo() {
        for i in 0...2 {
            let g: SKSpriteNode = SKSpriteNode(imageNamed: "Ground")
            g.name = "Ground"
            g.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            g.position = CGPoint(x: CGFloat(i) * g.size.width, y: -(self.frame.size.height / 2))
            g.zPosition = 3
            g.physicsBody = SKPhysicsBody(rectangleOf: g.size)
            g.physicsBody?.affectedByGravity = false
            g.physicsBody?.isDynamic = false
            g.physicsBody?.categoryBitMask = ColliderType.Ground
            self.addChild(g);
        }
    }
    func moverBGandG() {
        enumerateChildNodes(withName: "BG", using: ({
            (node, error) in
            let bgnode = node as! SKSpriteNode
            bgnode.position.x -= 4
            if bgnode.position.x < -(self.frame.width){
                bgnode.position.x += bgnode.size.width *  3
            }
        }))
        enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            let gnode = node as! SKSpriteNode
            gnode.position.x -= 4
            if gnode.position.x < -(self.frame.width){
                gnode.position.x += gnode.size.width *  3
            }
        }))
    }
    func crearObstaCULO() {
        for i in 0...5{
            let obstacle = SKSpriteNode(imageNamed: "Obstacle \(i)")
            if i == 0 {
                obstacle.name = "Cocktus"
                obstacle.setScale(0.4)
            } else {
                obstacle.name = "Obstacle"
                obstacle.setScale(0.5)
            }
            
            obstacle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            obstacle.zPosition = 1
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
            obstacle.physicsBody?.allowsRotation = false
            obstacle.physicsBody?.categoryBitMask = ColliderType.Obstacle
            obstacles.append(obstacle)
        }
    }
    func aparescanObstaCULOS() {
        let index = Int(arc4random_uniform(UInt32(obstacles.count)))
        let obstacle = obstacles[index].copy() as! SKSpriteNode;
        obstacle.position = CGPoint(x: self.frame.width + obstacle.size.width, y: 50)
        let move = SKAction.moveTo(x: (-(self.frame.size.width * 2)), duration: TimeInterval(15))
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, remove])
        obstacle.run(sequence)
        self.addChild(obstacle)
    }
    func randomBetweenNumbers(_ firstNumber: CGFloat, secondNumber: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber);
        
    }
}









