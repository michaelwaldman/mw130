//
//  GameViewController.swift
//  Space
//
//  Created by Michael on 9/21/14.
//  Copyright (c) 2014 Michael. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as Game
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}


class GameViewController: UIViewController {

    
    var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        var bgMusicURL: NSURL = NSBundle.mainBundle().URLForResource("bgmusic", withExtension: "mp3")!
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.volume = 0.5
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        var skView: SKView = self.view as SKView
              
        var scene:SKScene = Game.sceneWithSize(skView.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(scene)
        
        /* var ss:GameScene = GameScene(size: skView.bounds.size)
        var gameover:SKScene = GameOverScene.sceneWithSize(skView.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        let button = UIButton()
        button.frame = CGRectMake(100, 100, 100, 100)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Play Again", forState: UIControlState.Normal)
        if(ss.gameOver){
        skView.presentScene(gameover)
        }*/
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
