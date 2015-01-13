//
//  GameViewController.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 12/24/14.
//  Copyright (c) 2014 Tristen Miller. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var gameCenter: GameCenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenuScene(vc: self, size:CGSize(width: 2048, height: 1536))
        let skView = self.view as SKView
        self.gameCenter = GameCenter(rootViewController: self)
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    override func prefersStatusBarHidden() -> Bool  {
        return true
    }
    
    func openGC() {
        print("opening")
        gameCenter.showGameCenter()
    }
}
