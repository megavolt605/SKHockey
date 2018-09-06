//
//  Model.swift
//  SKHockey_case
//
//  Created by Igor Smirnov on 05/09/2018.
//  Copyright © 2018 Complex Numbers. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class PlayerModel {

    static let radius: CGFloat = 20.0

    var position: CGPoint {
        get { return node.position }
        set { node.position = newValue }
    }
    var desiredPosition = CGPoint.zero
    var node: SKShapeNode
    init() {
        node = SKShapeNode(circleOfRadius: PlayerModel.radius)
        node.fillColor = .green
        node.physicsBody = SKPhysicsBody(circleOfRadius: PlayerModel.radius)
    }

}

class TargetModel {
    var position: CGPoint {
        get { return node.position }
        set { node.position = newValue }
    }
    var node: SKShapeNode
    init(radius: CGFloat) {
        node = SKShapeNode(circleOfRadius: radius)
        node.fillColor = .yellow
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius)
    }
}

class GameModel {

    enum State {
        case initial, running, finished
    }

    var player = PlayerModel()
    var targets: [TargetModel] = []

    var state: State = .initial {
        didSet {
            switch state {
            case .running:
                start()
            case .finished:
                stop()
            default: break
            }
        }
    }

    var targetCount = 5
    var scene = GameScene()

    var motion = CMMotionManager()

    private func clear() {
        player.node.removeFromParent()
        targets.forEach { $0.node.removeFromParent() }
        targets = []
    }

    private func start() {
        clear()
        player = PlayerModel()
        player.position = scene.size.center
        scene.addChild(player.node)

        for _ in 0..<targetCount {
            let radius = (10.0..<30.0).random
            let target = TargetModel(radius: radius)
            let positionX = (radius..<scene.size.width - radius).random
            let positionY = (radius..<scene.size.height - radius).random
            target.position = CGPoint(x: positionX, y: positionY)
            scene.addChild(target.node)
            targets.append(target)
        }

        motion.startAccelerometerUpdates(to: OperationQueue.main) { data, error in
            guard let acceleration = data?.acceleration else { return }
            self.player.desiredPosition = CGPoint(
                x: self.player.position.x + CGFloat(acceleration.x * 100.0),
                y: self.player.position.y + CGFloat(acceleration.y * 100.0)
            )
        }

    }

    private func stop() {
        clear()
        motion.stopAccelerometerUpdates()
    }

    func process() {
        let moveX = SKAction.moveTo(x: player.desiredPosition.x, duration: 0.2)
        let moveY = SKAction.moveTo(y: player.desiredPosition.y, duration: 0.2)
        let move = SKAction.group([moveX, moveY])
        player.node.run(move)
    }

    init() {
        scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        scene.model = self
    }

}

class GameScene: SKScene {

    weak var model: GameModel?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        ///
    }

    override func update(_ currentTime: TimeInterval) {
        //print(currentTime)
        model?.process()
    }

}
