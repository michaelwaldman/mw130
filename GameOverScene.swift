//
//  GameOverScene.swift
//  Space
//
//  Created by Michael on 9/21/14.
//  Copyright (c) 2014 Michael. All rights reserved.
//

import UIKit
import SpriteKit
var communicationBool:Bool = Bool()
class GameScene: SKScene {
    var com2: AppDelegate = AppDelegate()
    var pdod : Game?
    var playagainbutton:SKSpriteNode = SKSpriteNode(imageNamed: "playagainbtn1")
    var play1:SKTexture = SKTexture(imageNamed: "playagainbtn1")
    var play2:SKTexture = SKTexture(imageNamed: "playagainbtn2")
    var fsad:Game = Game(size: CGSize(width: 500, height: 500))
    var game: Game? = Game()
    var actualScore = 0
    func gameEnded() {
        let gameOver = Game(piecesDodged: self.game!.piecesDodged) // or whatever the property for your highscore is
    }
    override func didMoveToView(view: SKView) {
          }

    override func update(currentTime: NSTimeInterval) {
        if(communicationBool == true){
            self.runAction(SKAction.runBlock({
                var transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
                var scene: SKScene = Game(size: self.size)
                self.view?.presentScene(scene, transition: transition)
                communicationBool = false
                accessVar.gameScore = 0
            })
            )
        }
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if(location.x>self.size.width/2 - 100 && location.x<self.size.width/2 + 100 && location.y>self.size.height/2 - 100 && location.y < self.size.height/2 + 100){
                communicationBool = true
                
                var changePic = SKAction.animateWithTextures([play2, play1], timePerFrame: 0.001)
                playagainbutton.runAction(changePic)
            }
        }
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        var changePic = SKAction.animateWithTextures([play1, play2], timePerFrame: 0.001)
        playagainbutton.runAction(changePic)
        
    }
   
    override init(size: CGSize){

        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        
        var message: NSString = NSString()
        var score1: NSString = NSString()
            message = "Game Over"
            score1 = "Score: " + String(accessVar.gameScore)
        
        var label: SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
        label.text = message
        label.fontColor = SKColor.whiteColor()
        label.fontSize = 30
        label.position = CGPointMake(self.size.width/2, self.size.height/2+100)
        
        var scoreLabel:SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
        scoreLabel.text = score1
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(label)
        self.addChild(scoreLabel)
        
        playagainbutton.position = CGPointMake(self.size.width/2, self.size.height/2 - 60)
        self.addChild(playagainbutton)
    
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

  
