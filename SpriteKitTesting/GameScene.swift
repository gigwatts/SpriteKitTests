//
//  GameScene.swift
//  SpriteKitTesting
//
//  Created by Dustin Watts on 2/23/16.
//  Copyright (c) 2016 <?xml version="1.0" encoding="UTF-8"?>


//<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
//<plist version="1.0">
//<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
//</plist>
//Dustin Watts. All rights reserved.
//

import SpriteKit
//import AVFoundation
//import AudioToolbox
//import Foundation
import UIKit
import AudioKit


//Audio Example
var engine: AVAudioEngine!
var tone: AVTonePlayerUnit!

var QuarterNote:SKSpriteNode!
var touchLocation:CGPoint = CGPointZero
var tempoLabel: SKLabelNode!
var button: SKNode!
var minusButton: SKNode!
var plusButton: SKNode!
var metronomeIsOn = false
var metronomeTimer:NSTimer!
var frequencyTimer:NSTimer!
var tempo:NSTimeInterval = 60
var i = 0
var tunerButton: SKNode!
var collectingFrequencies = false
var freqDetected = 0.0
var freqLabel: SKLabelNode!
var beat:Int = -5

//Tone Generation buttons
var freq = 440
var freqGeneratedLabel: SKLabelNode!
var playTone: SKNode!
var freqMinusButton: SKNode!
var freqPlusButton: SKNode!
var micSetup = false
var freqTracker: AKFrequencyTracker!

var noteFreqLookup = ["lowD":294, "E":329, "FSharp":370, "G":390, "A":440, "B":495, "CSharp":558, "highD": 588]

//Musical note nodes
var lowD: SKNode!
var E: SKNode!
var FSharp: SKNode!
var G: SKNode!
var A: SKNode!
var B: SKNode!
var CSharp: SKNode!
var highD: SKNode!

//Beat Indicator nodes
var lowDBG: SKNode!
var EBG: SKNode!
var FSharpBG: SKNode!
var GBG: SKNode!
var ABG: SKNode!
var BBG: SKNode!
var CSharpBG: SKNode!
var highDBG: SKNode!
var countdownLabel: SKLabelNode!
var countdownBG: SKNode!

//Initialize array that will hold frequencies captured
var freqExpectedArray = [294, 329, 370, 390, 440, 495, 558, 588]
var freqPlayed = [Int]()
var accuracyMatrix = [Int]()
var lowDArray = [Int]()
var EArray = [Int]()
var FSharpArray = [Int]()
var GArray = [Int]()
var AArray = [Int]()
var BArray = [Int]()
var CSharpArray = [Int]()
var highDArray = [Int]()

//tracking measure that needs work
var troubleStart: Int = 1

class GameScene: SKScene {

    
    //TODO: Aure, all of the AudioKit code is in the section below. The next TODO note is the end of AudioKit code. Thanks for reviewing. Note setupMic is triggered by an NSTimer.
    func setupMic(){
        if !micSetup{
            AKSettings.audioInputEnabled = true //per post: https://groups.google.com/forum/#!searchin/audiokit/AKMicrophone/audiokit/3eVbbut65CM/BoQQbxo3CAAJ            
            let mic = AKMicrophone()
            mic.start()
            freqTracker = AKFrequencyTracker.init(mic, minimumFrequency: 25, maximumFrequency: 4200)
            let silence = AKBooster(freqTracker, gain: 0)
            AudioKit.output = silence //per post: https://groups.google.com/forum/#!searchin/audiokit/AKMicrophone$20silence/audiokit/L9tb9TRL9bs/y3rqvdw1CAAJ

            AudioKit.start()
            micSetup = true
        } else{
        freqDetected = freqTracker.frequency
        freqLabel.text = String(Int(freqDetected))
            if ((beat >= 0) && ((troubleStart+beat) == 1)){
                fadeOut(countdownBG, alpha: 0)
                fadeIn(lowDBG)
                if(freqDetected > 100 && freqDetected < 2000){
                    lowDArray.append(Int(freqDetected))
                }
            }
            if ((beat >= 0) && ((troubleStart+beat) == 2)){
                fadeOut(lowDBG, alpha: 0)
                fadeIn(EBG)
                evaluateNotePlayed(lowDArray, noteExpected: noteFreqLookup["lowD"]!, noteNode: (lowD)!)
                if(freqDetected > 100 && freqDetected < 2000){
                    EArray.append(Int(freqDetected))
                }
            }
            if ((beat >= 0) && ((troubleStart+beat) == 3)){
                fadeOut(EBG, alpha: 0)
                fadeIn(FSharpBG)
                evaluateNotePlayed(EArray, noteExpected: noteFreqLookup["E"]!, noteNode: (E)!)
                if(freqDetected > 100 && freqDetected < 2000){
                    FSharpArray.append(Int(freqDetected))
                }
            }
            if ((beat >= 0) && ((troubleStart+beat) == 4)){
                fadeOut(FSharpBG, alpha: 0)
                fadeIn(GBG)
                evaluateNotePlayed(FSharpArray, noteExpected: noteFreqLookup["FSharp"]!, noteNode: (FSharp)!)
                if(freqDetected > 100 && freqDetected < 2000){
                    GArray.append(Int(freqDetected))
                }
            }
            if ((beat >= 0) && ((troubleStart+beat) == 5)){
                fadeOut(GBG, alpha: 0)
                fadeIn(ABG)
                evaluateNotePlayed(GArray, noteExpected: noteFreqLookup["G"]!, noteNode: (G)!)
                if(freqDetected > 100 && freqDetected < 2000){
                    AArray.append(Int(freqDetected))
                }
            }
            if ((beat >= 0) && ((troubleStart+beat) == 6)){
                fadeOut(ABG, alpha: 0)
                fadeIn(BBG)
                evaluateNotePlayed(AArray, noteExpected: noteFreqLookup["A"]!, noteNode: (A)!)
                if(freqDetected > 100 && freqDetected < 2000){
                    BArray.append(Int(freqDetected))
                }
            }
            if ((beat >= 0) && ((troubleStart+beat) == 7)){
                fadeOut(BBG, alpha: 0)
                fadeIn(CSharpBG)
                evaluateNotePlayed(BArray, noteExpected: noteFreqLookup["B"]!, noteNode: (B)!)
                if(freqDetected > 100 && freqDetected < 2000){
                    CSharpArray.append(Int(freqDetected))
                }
            }
            if ((beat >= 0) && ((troubleStart+beat) == 8)){
                fadeOut(CSharpBG, alpha: 0)
                fadeIn(highDBG)
                evaluateNotePlayed(CSharpArray, noteExpected: noteFreqLookup["CSharp"]!, noteNode: (CSharp)!)
                if(freqDetected > 100 && freqDetected < 2000){
                    highDArray.append(Int(freqDetected))
                }
            }
            if ((beat >= 0) && ((troubleStart+beat) == 9)){
               
                stopMetronome()
                fadeOut(highDBG, alpha: 0)
                evaluateNotePlayed(highDArray, noteExpected: noteFreqLookup["highD"]!, noteNode: (highD)!)

            }

        print("FREQUENCY: ", freqDetected);
        }
    }
    
    
    func stopMic(){
        AudioKit.stop()
        micSetup = false
    }
    
    
    //TODO: END of AudioKit code
    
    
    
    
    
    func fadeOut(note: SKNode, alpha: CGFloat){
        note.runAction(SKAction.fadeAlphaTo(alpha, duration: 0.1))
    }

    func fadeIn(note: SKNode){
        note.runAction(SKAction.fadeAlphaTo(1, duration: 0.05))
    }
    
    func averageArray(freqArray:Array<Int>) -> Int{
        var sum = 0
        var average:Int = 0
        if(freqArray.count > 0){
            for freq in freqArray{
                sum += freq
            }
            average = sum/freqArray.count
        }
        return average
    }
    
    
    func averageIndexRangeOFArray(array:Array<Int>,startIndex:Int, endIndex:Int) -> Int{
        var sum = 0
        var average:Int = 0
        var index = startIndex
        if(array.count > 0){
            while(index<endIndex){
                sum += array[index]
                index++
            }
            average = sum/(endIndex-startIndex)
        }
        return average
    }
    
    
    
    
    
    func evaluateNotePlayed(freqDetectedArray:Array<Int>, noteExpected: Int, noteNode:SKNode){
        var freqDetected = averageArray(freqDetectedArray)
        if(abs(freqDetected - noteExpected)<20){
            fadeOut(noteNode, alpha: 0.1)
            accuracyMatrix.append(100)
        } else{
            accuracyMatrix.append(0)
        }
    }
    
    func hideNoteBGs(){
        fadeOut(lowDBG, alpha: 0)
        fadeOut(EBG, alpha: 0)
        fadeOut(FSharpBG, alpha: 0)
        fadeOut(GBG, alpha: 0)
        fadeOut(ABG, alpha: 0)
        fadeOut(BBG, alpha: 0)
        fadeOut(CSharpBG, alpha: 0)
        fadeOut(highDBG, alpha: 0)
        fadeOut(countdownBG, alpha: 0)
//        fadeOut(countdownLabel, alpha: 0)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //QuarterNote = self.childNodeWithName("QuarterNote") as! SKSpriteNode
        tempoLabel = SKLabelNode(fontNamed:"Helvetica Neue UltraLight")
        tempoLabel.text = String(Int(tempo))
        tempoLabel.fontSize = 120
        tempoLabel.fontColor = SKColor.blackColor()
        tempoLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:150)
        self.addChild(tempoLabel)
        
        //ADDING BUTTON TO BE PRESSED
        button = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: 200, height: 200))
        // Put it in the center of the scene
        button.position = CGPoint(x:CGRectGetMidX(self.frame), y:200);
        self.addChild(button)
        
        let minusLabel = SKLabelNode(fontNamed:"Helvetica Neue UltraLight")
        minusLabel.text = "-"
        minusLabel.fontSize = 200
        minusLabel.fontColor = SKColor.blackColor()
        minusLabel.position = CGPoint(x:CGRectGetMidX(self.frame)-200, y:130)
        self.addChild(minusLabel)
        
        //ADDING BUTTON TO BE PRESSED
        minusButton = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 200, height: 200))
        // Put it in the center of the scene
        minusButton.position = CGPoint(x:CGRectGetMidX(self.frame)-200, y:200);
        self.addChild(minusButton)

        let plusLabel = SKLabelNode(fontNamed:"Helvetica Neue UltraLight")
        plusLabel.text = "+"
        plusLabel.fontSize = 120
        plusLabel.fontColor = SKColor.blackColor()
        plusLabel.position = CGPoint(x:CGRectGetMidX(self.frame)+200, y:150)
        self.addChild(plusLabel)
        
        //ADDING BUTTON TO BE PRESSED
        plusButton = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 200, height: 200))
        // Put it in the center of the scene
        plusButton.position = CGPoint(x:CGRectGetMidX(self.frame)+200, y:200);
        self.addChild(plusButton)
        
        
        //TONE GENERATION BUTTONS
        /* Setup your scene here */
        //QuarterNote = self.childNodeWithName("QuarterNote") as! SKSpriteNode
        freqGeneratedLabel = SKLabelNode(fontNamed:"Helvetica Neue UltraLight")
        freqGeneratedLabel.text = String(freq)
        freqGeneratedLabel.fontSize = 120
        freqGeneratedLabel.fontColor = SKColor.blackColor()
        freqGeneratedLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:0)
        self.addChild(freqGeneratedLabel)
        
        //ADDING BUTTON TO BE PRESSED
        playTone = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: 200, height: 200))
        // Put it in the center of the scene
        playTone.position = CGPoint(x:CGRectGetMidX(self.frame), y:0);
        self.addChild(playTone)
        
        //ADDING TUNER BUTTON
        tunerButton = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 200, height: 200))
        // Put it in the center of the scene
        tunerButton.position = CGPoint(x:CGRectGetMidX(self.frame)-100, y:CGRectGetMidY(self.frame) + 350)
        self.addChild(tunerButton)
        
        let freqMinusLabel = SKLabelNode(fontNamed:"Helvetica Neue UltraLight")
        freqMinusLabel.text = "-"
        freqMinusLabel.fontSize = 200
        freqMinusLabel.fontColor = SKColor.blackColor()
        freqMinusLabel.position = CGPoint(x:CGRectGetMidX(self.frame)-200, y:0)
        self.addChild(freqMinusLabel)
        
        //ADDING BUTTON TO BE PRESSED
        freqMinusButton = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 200, height: 200))
        // Put it in the center of the scene
        freqMinusButton.position = CGPoint(x:CGRectGetMidX(self.frame)-200, y:0);
        self.addChild(freqMinusButton)
        
        let freqPlusLabel = SKLabelNode(fontNamed:"Helvetica Neue UltraLight")
        freqPlusLabel.text = "+"
        freqPlusLabel.fontSize = 120
        freqPlusLabel.fontColor = SKColor.blackColor()
        freqPlusLabel.position = CGPoint(x:CGRectGetMidX(self.frame)+200, y:0)
        self.addChild(freqPlusLabel)
        
        //ADDING BUTTON TO BE PRESSED
        freqPlusButton = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 200, height: 200))
        // Put it in the center of the scene
        freqPlusButton.position = CGPoint(x:CGRectGetMidX(self.frame)+200, y:0);
        self.addChild(freqPlusButton)
        
        //Firing up the Audio Engine
        tone = AVTonePlayerUnit()
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        print(format.sampleRate)
        engine = AVAudioEngine()
        engine.attachNode(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
        
        //Frequency Detected Display
        freqLabel = SKLabelNode(fontNamed:"Helvetica Neue UltraLight")
        freqLabel.text = "0"
        freqLabel.fontSize = 120
        freqLabel.fontColor = SKColor.redColor()
        freqLabel.position = CGPoint(x:CGRectGetMidX(self.frame) + 150, y:CGRectGetMidY(self.frame) + 300)
        self.addChild(freqLabel)
        
        
        
        //add musical notes to scene
        lowD = self.childNodeWithName("lowD") as? SKSpriteNode
        E = self.childNodeWithName("E") as? SKSpriteNode
        FSharp = self.childNodeWithName("FSharp") as? SKSpriteNode
        G = self.childNodeWithName("G") as? SKSpriteNode
        A = self.childNodeWithName("A") as? SKSpriteNode
        B = self.childNodeWithName("B") as? SKSpriteNode
        CSharp = self.childNodeWithName("CSharp") as? SKSpriteNode
        highD = self.childNodeWithName("highD") as? SKSpriteNode
        
        //add backgrounds for each musical notes in the scene and countdown
        lowDBG = self.childNodeWithName("lowDBG") as? SKSpriteNode
        EBG = self.childNodeWithName("EBG") as? SKSpriteNode
        FSharpBG = self.childNodeWithName("FSharpBG") as? SKSpriteNode
        GBG = self.childNodeWithName("GBG") as? SKSpriteNode
        ABG = self.childNodeWithName("ABG") as? SKSpriteNode
        BBG = self.childNodeWithName("BBG") as? SKSpriteNode
        CSharpBG = self.childNodeWithName("CSharpBG") as? SKSpriteNode
        highDBG = self.childNodeWithName("highDBG") as? SKSpriteNode
        countdownLabel = self.childNodeWithName("countdownLabel") as? SKLabelNode
        countdownBG = self.childNodeWithName("countdownBG") as? SKSpriteNode
        

        hideNoteBGs()
        
//        setupMic()
    }

    func playSound(soundName: String){
        if(beat<=0){
            countdownLabel.text = String(((beat)*(-1))-1)
        }
        beat++
        runAction(SKAction.playSoundFileNamed("\(soundName).wav", waitForCompletion: false))
//        if (beat == 5){
//            
//        }


    }
    
    func representBeat(){
        playSound("PingA")
    }
    
    
    func determineTroubleSpotStart(){
        if(averageArray(accuracyMatrix)<100){
            print("STOP HERE: ", accuracyMatrix)
            let measureOneAccuracy = averageIndexRangeOFArray(accuracyMatrix, startIndex: 0, endIndex: ((accuracyMatrix.count)/2))
            let measureTwoAccuracy = averageIndexRangeOFArray(accuracyMatrix, startIndex: ((accuracyMatrix.count)/2), endIndex: (accuracyMatrix.count))
            if(measureOneAccuracy > measureTwoAccuracy){
                troubleStart = 5
            } else{
                troubleStart = 1
            }
        } else{
            troubleStart =  1
        }
        beat = -5
    }
    
    func startMetronome(){
        // Mark the metronome as on.
        fadeIn(countdownBG)
        accuracyMatrix.removeAll()
        lowDArray.removeAll()
        EArray.removeAll()
        FSharpArray.removeAll()
        GArray.removeAll()
        AArray.removeAll()
        BArray.removeAll()
        CSharpArray.removeAll()
        highDArray.removeAll()
        
        
        if(troubleStart==1){
            fadeIn(lowDBG)
        } else if (troubleStart==5){
            fadeIn(ABG)
        }
        
        metronomeIsOn = true
        let metronomeTimeInterval:NSTimeInterval = 60.0 / (tempo)
        metronomeTimer = NSTimer.scheduledTimerWithTimeInterval(metronomeTimeInterval, target: self, selector: Selector("representBeat"), userInfo: nil, repeats: true)
        metronomeTimer?.fire()
    }
    
    func stopMetronome(){
        // Mark the metronome as off.
        metronomeIsOn = false
        // Stop the metronome.
        metronomeTimer?.invalidate()
//        beat = 0
        if(averageArray(accuracyMatrix)<60){
            print ("try again at a slower tempo")
            tempo = tempo - 5
            tempoLabel.text = String(Int(tempo))
        } else if(averageArray(accuracyMatrix)<100){
            print("Not bad. If you get 100% we will speed up the tempo!")
        }else{
            print ("Nice work! Now try a faster tempo.")
            tempo = tempo + 10
            tempoLabel.text = String(Int(tempo))
        }
        
        fadeIn(lowD)
        fadeIn(E)
        fadeIn(FSharp)
        fadeIn(G)
        fadeIn(A)
        fadeIn(B)
        fadeIn(CSharp)
        fadeIn(highD)
        
        determineTroubleSpotStart()

    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        /* Called when a touch begins */
        touchLocation = touches.first!.locationInNode(self)
        
        for touch in touches {
            
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if button.containsPoint(location) {
                print("toggle metronome")
                var sum = 0
                for freq in AArray{
                    sum += freq
                }
                if(AArray.count > 0){
                    freqPlayed.append(sum/AArray.count)
                }
                print(freqPlayed)
                print("low D (294): ", lowDArray)
                print("E (329): ", EArray)
                print("F Sharp (370): ", FSharpArray)
                print("G (390): ", GArray)
                print("A (440): ", AArray)
                print("B (495): ", BArray)
                print("C Sharp (558): ", CSharpArray)
                print("high D (588): ", highDArray)
                print("Accuracy Matrix: ", accuracyMatrix)
                print("Percent Correct: ", averageArray(accuracyMatrix))
                
//                var freqExpectedArray = [294, 329, 370, 390, 440, 495, 558, 588]
                
                if metronomeIsOn {
                    stopMetronome()
                }
                else {
                    startMetronome()
                }
            }
            
            if minusButton.containsPoint(location) {
                tempo = tempo - 10
                tempoLabel.text = String(Int(tempo))
            }
            if plusButton.containsPoint(location) {
                tempo = tempo + 10
                tempoLabel.text = String(Int(tempo))
            }
            
            if playTone.containsPoint(location){
                print("toggle tone generator");
                if tone.playing {
                    engine.mainMixerNode.volume = 0.0
                    tone.stop()
                    //sender.setTitle("Start", forState: .Normal)
                } else {
                    tone.preparePlaying()
                    tone.play()
                    engine.mainMixerNode.volume = 1.0
                    //sender.setTitle("Stop", forState: .Normal)
                }
            }
            
            
            if tunerButton.containsPoint(location){
                if !collectingFrequencies {
                    //stop collecting data
                    collectingFrequencies = true
                    print("COLLECTING FREQUENCIES")
                    frequencyTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("setupMic"), userInfo: nil, repeats: true)
                    frequencyTimer?.fire()

                } else {
                   //iteratively collect data until stopped
                    collectingFrequencies = false
                    print("STOP COLLECTING FREQUENCIES")
                    frequencyTimer?.invalidate()
                    stopMic()
                }
            }
            
            if freqMinusButton.containsPoint(location) {
                tone.frequency = Double(tone.frequency - 10)
                freqGeneratedLabel.text = String(Int(tone.frequency))
            }
            if freqPlusButton.containsPoint(location) {
                tone.frequency = Double(tone.frequency + 10)
                freqGeneratedLabel.text = String(Int(tone.frequency))
            }
            
//            let game:Tuner = Tuner(fileNamed: "Tuner")!
//            game.scaleMode = .AspectFill
//            //let transition:SKTransition = SKTransition.crossFadeWithDuration(0.0)
//            self.view?.presentScene(game) //, transition: transition)
        }
    }
   
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }

}
