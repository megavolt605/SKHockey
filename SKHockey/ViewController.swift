//
//  ViewController.swift
//  SKHockey_case
//
//  Created by Igor Smirnov on 05/09/2018.
//  Copyright © 2018 Complex Numbers. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var startStopButton: UIButton!

    var game = GameModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.presentScene(game.scene)
        gameView.showsFPS = true
        gameView.showsNodeCount = true

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        game.scene.size = gameView.bounds.size
    }

    @IBAction func startStopButtonAction(_ sender: Any) {
        switch game.state {
        case .running:
            game.state = .finished
        default:
            game.state = .running
        }
    }

}

