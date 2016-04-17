//
//  Tuner.swift
//  SpriteKitTesting
//
//  Created by Dustin Watts on 3/15/16.
//  Copyright © 2016 Dustin Watts. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

class RandomTone: SKScene {
    
    var toneTap: SKNode!
    var touchLocation:CGPoint = CGPointZero
    var toneIsOn = false
    var oscillator = AKOscillator()
    
    func viewDidLoad() {

//        AudioKit.output = oscillator
//        AudioKit.start()
        
    }
    
    
    override func didMoveToView(view: SKView) {
        AudioKit.output = oscillator
        AudioKit.start()
        
        //Adding the toneTap button
        toneTap = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 200, height: 200))
        // Put it in the center of the scene
        toneTap.position = CGPoint(x:CGRectGetMidX(self.frame), y:200);
        self.addChild(toneTap)
    }
    
    @IBAction func toggleSound(sender: UIButton) {
        if oscillator.isPlaying {
            oscillator.stop()
            sender.setTitle("Play Sine Wave", forState: .Normal)
        } else {
            oscillator.amplitude = random(0.5, 1)
            oscillator.frequency = random(220, 880)
            oscillator.start()
            sender.setTitle("Stop Sine Wave at \(Int(oscillator.frequency))Hz", forState: .Normal)
        }
        sender.setNeedsDisplay()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        /* Called when a touch begins */
        touchLocation = touches.first!.locationInNode(self)
        
        for touch in touches {
            
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if toneTap.containsPoint(location) {
                print("PLAY A TONE")
                
                if toneIsOn {
                    // Mark the metronome as off.
                    toneIsOn = false
                    print("STOPPING OSCILLATOR")
                    oscillator.stop()
//                    sender.setTitle("Play Sine Wave", forState: .Normal)
                }

                else {
                    toneIsOn = true
                    oscillator.amplitude = random(0.5, 1)
                    oscillator.frequency = random(220, 880)
                    print("STARTING OSCILLATOR")
                    oscillator.start()
//                    sender.setTitle("Stop Sine Wave at \(Int(oscillator.frequency))Hz", forState: .Normal)
                }
            }
        }
    }
}