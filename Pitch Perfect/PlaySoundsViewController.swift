//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sheethal Shenoy on 2/3/16.
//  Copyright © 2016 Sheethal Shenoy. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var avplayer: AVAudioPlayer!
    var recordedAudio : RecordedAudio!
    var engine: AVAudioEngine!
    var audiofile: AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! avplayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePath)
        avplayer.enableRate = true
        
        engine = AVAudioEngine()
        try! audiofile = AVAudioFile(forReading: recordedAudio.filePath)
        
    }
    
    
    func playAudioWithVariablePitch(pitch:Float) {
        avplayer.stop()
        engine.stop()
        engine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        engine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        engine.attachNode(changePitchEffect)
        print("play chipmunk audio pitch", pitch)
        engine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        engine.connect(changePitchEffect, to: engine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audiofile, atTime: nil, completionHandler: nil)
        try! engine.start()
        audioPlayerNode.play()
        
    }

    @IBAction func stopAudio(sender: AnyObject) {
        avplayer.stop()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
       
    @IBAction func playSlow(sender: AnyObject) {
        avplayer.currentTime = 0.0
        stopAndPlay(0.5)
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        print("play chipmunk audio")
        playAudioWithVariablePitch(1000)
    }
    
    func stopAndPlay(varB:Float){
        avplayer.stop()
        avplayer.rate = varB
        avplayer.play()
    }

    @IBAction func playFast(sender: AnyObject) {
        avplayer.currentTime = 0.0
        stopAndPlay(2.0)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
