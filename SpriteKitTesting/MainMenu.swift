//
//  MainMenu.swift
//  SpriteKitTesting
//
//  Created by Dustin Watts on 2/23/16.
//  Copyright © 2016 Dustin Watts. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFill
        let transition:SKTransition = SKTransition.crossFadeWithDuration(1.0)
        self.view?.presentScene(game, transition: transition)
    }
}
