//
//  GameScene.swift
//  Space
//
//  Created by Michael on 9/21/14.
// Copyright (c) 2014 Michael. All rights reserved.
//

import SpriteKit
import AVFoundation

class Game: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode = SKSpriteNode()
    var lastYieldTimeInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateTimerInterval:NSTimeInterval = NSTimeInterval()
    var aliensDestroyed: Int = 0
    var gravityVector:CGFloat = -0.70
    var pixelman = SKSpriteNode()
    var background = SKTexture(imageNamed: "pixelSkyBG")
    let alienCategory: UInt32 = 0x1 << 1
    let photonTorpedoCategory: UInt32 = 0x1 << 0
    var distToMoveLeft = 0
    var distToMoveRight = 0
    var bool = true
    var moveAndRemove = SKAction()
    let moveToTheRight = SKAction.moveByX(30, y: 0, duration: NSTimeInterval(1))
    let moveToTheLeft = SKAction.moveByX(-30, y: 0, duration: NSTimeInterval(1))
    let cloud1 = SKSpriteNode(imageNamed: "finalCloud")
    let cloud2 = SKSpriteNode(imageNamed: "finalCloud2")
    let cloud3 = SKSpriteNode(imageNamed: "cloudForPix3")
    let moveUpObject = SKAction.moveToY(1000, duration: 5)
    let moveDownObject = SKAction.moveByX(0, y: -600, duration: 5)
    let fakeNode = SKSpriteNode()
    var random = arc4random()
    let fallSprite = SKSpriteNode()
    var fallSpriteTexture = SKTexture(imageNamed: "rainbowMM")
    var fallSpriteTexture2 = SKTexture(imageNamed: "rainbowM22")
    let heroHitCategory:UInt32? = 0x1 << 0
    let meteorHitCategory:UInt32? = 0x1 << 1
    var gameOver:Bool = false
    var piecesDodged = 0
    var allowMovement:Bool = true
    var heart1:SKSpriteNode = SKSpriteNode(imageNamed: "heart")
    var heart2:SKSpriteNode = SKSpriteNode(imageNamed: "heart")
    var heart3:SKSpriteNode = SKSpriteNode(imageNamed: "heart")
    var lives = 3
    let moveBackToTheLeft = SKAction.repeatActionForever(SKAction.moveByX(-10, y: 0, duration: 1))
    let moveBackToTheRight = SKAction.repeatActionForever(SKAction.moveByX(10, y: 0, duration: 1))
    var highScore = 0
    
    let cloudMove = NSTimeInterval(Int(arc4random()%10))
    let cloudMove2 = NSTimeInterval(Int(arc4random()%10))

    var needsToMoveRight:Bool = false
    var needsToMoveLeft:Bool = false


    var backgroundMusicPlayer1: AVAudioPlayer = AVAudioPlayer()
    var bgMusicURL1: NSURL = NSBundle.mainBundle().URLForResource("dead", withExtension: "wav")!
    
    var scoreLabel: SKLabelNode = SKLabelNode(fontNamed: "DINCondensed-Bold")
    var scoreVarInLabel:NSString=NSString()

    override func didMoveToView(view: SKView) {
        
        scoreVarInLabel = ""
        scoreLabel.text =  scoreVarInLabel + String(accessVar.gameScore)
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.fontSize = 35
        scoreLabel.position = CGPointMake(25, self.size.height-35)
        scoreLabel.zPosition = 10
        
        
        
        
        self.addChild(scoreLabel)
        heart1.position = CGPointMake(self.frame.width - 15, self.frame.height - 20)
        heart1.zPosition = 10
        self.addChild(heart1)
        heart2.position = CGPointMake(self.frame.width - 45, self.frame.height - 20)
        heart2.zPosition = 10
        self.addChild(heart2)
        heart3.position = CGPointMake(self.frame.width - 75, self.frame.height - 20)
        heart3.zPosition = 10
        self.addChild(heart3)
        var pixelmanTexture = SKTexture(imageNamed: "pixelperson")
        pixelmanTexture.filteringMode = SKTextureFilteringMode.Nearest
        pixelman = SKSpriteNode(texture: pixelmanTexture)
    
        
        background.filteringMode = SKTextureFilteringMode.Nearest
        let bg = SKSpriteNode(texture: background)
        bg.position = CGPointMake(frame.width / 2, (frame.height / 2)+100)
        
        pixelman.position = CGPointMake(self.frame.width/2, 50)
        pixelman.xScale = 1.5
        pixelman.yScale = 1.5
        pixelman.zPosition = 5
        //pixelman.physicsBody?.mass = 0.00001
        
        //pixelman.physicsBody = SKPhysicsBody(circleOfRadius: pixelman.size.width/2)
        pixelman.physicsBody = SKPhysicsBody(rectangleOfSize: pixelman.size)
        pixelman.physicsBody?.dynamic = true
        pixelman.physicsBody?.categoryBitMask = heroHitCategory!
        pixelman.physicsBody?.contactTestBitMask = alienCategory
        pixelman.physicsBody?.collisionBitMask = 0
        pixelman.physicsBody?.usesPreciseCollisionDetection = true
        
        fallSpriteTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        fallSprite.position = CGPointMake(400, 600)
        
        
        let moveEnemy = SKAction.moveByX(0.0, y: -self.frame.size.height, duration:NSTimeInterval(7))
        let removeEnemy = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveEnemy,removeEnemy])
        
        
        cloud1.position = CGPointMake(-200, self.frame.height/2 + 200)
        cloud2.position = CGPointMake(-200, self.frame.height/2 + 300)
        moveClouds()
        
        if(pixelman.position.x>self.frame.width-30){
            pixelman.runAction(SKAction.repeatActionForever(moveToTheLeft))
        }
        if(needsToMoveRight == true){
            println("ehuiudhiakjnl")
            pixelman.runAction(moveToTheRight)
        }
        
     
        
       /* var fakeSpriteNode1:SKSpriteNode = SKSpriteNode(imageNamed: "startbuttonsquare")
        fakeSpriteNode1.position = CGPointMake(450, 0)

        fakeSpriteNode1.physicsBody = SKPhysicsBody(rectangleOfSize: fakeSpriteNode1.size)
        fakeSpriteNode1.physicsBody?.dynamic = false
        fakeSpriteNode1.zPosition = 5*/
        
       // fakeSpriteNode1.physicsBody?.mass = 500000
       // self.addChild(fakeSpriteNode1)
        
        
        self.addChild(bg)
        self.addChild(pixelman)
        self.addChild(cloud1)
        self.addChild(cloud2)
    

        
    }
    
    init(piecesDodged: Int) {
        self.piecesDodged = piecesDodged
        super.init()
    }
    override init() {
        super.init()
    }
    
    override init(size: CGSize){
        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        player = SKSpriteNode(imageNamed: "pixelperson")
        
        player.position = CGPointMake(self.frame.size.width/2, player.size.height/2 + 20)
        self.addChild(player)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addScore(){
        accessVar.gameScore++
    }
    
    func playCrashSound(){
        backgroundMusicPlayer1 =  AVAudioPlayer(contentsOfURL: bgMusicURL1, error: nil)
        backgroundMusicPlayer1.prepareToPlay()
        backgroundMusicPlayer1.play()

    }
    func addAlien(){
        var alien: SKSpriteNode = SKSpriteNode(imageNamed: "fireObj1")
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: alien.size)
        alien.physicsBody?.dynamic = true
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = heroHitCategory!
        alien.physicsBody?.collisionBitMask = 0
        alien.yScale = 0.70
        alien.xScale = 0.60
        let moveObj = SKAction.animateWithTextures([fallSpriteTexture, fallSpriteTexture2], timePerFrame: 0.1)
        let repeatMovement = SKAction.repeatActionForever(moveObj)
        alien.runAction(repeatMovement)
        
        let minX = alien.size.width/2
        let maxX = self.frame.size.width - alien.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()) % CGFloat(rangeX) + CGFloat(minX)
        
        alien.position = CGPointMake(position, self.frame.size.height+alien.size.height)
        
        self.addChild(alien)
        
        let minDuration = 1.25
        let maxDuration = 3.25
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random()) % Int(rangeDuration) + Int(minDuration)
        var moveTheSprite = SKAction.moveTo(CGPointMake(position, -alien.size.height), duration: NSTimeInterval(duration))
        var addPoints = SKAction.runBlock({self.addScore()})
        var actionArray:NSMutableArray = NSMutableArray()
        actionArray.addObject(moveTheSprite)
        actionArray.addObject(addPoints)
        actionArray.addObject(SKAction.removeFromParent())
        alien.runAction(SKAction.sequence(actionArray))
        if(gameOver == true){
            alien.removeActionForKey("moveTheSprite")
            var bringUpScene = SKAction.runBlock({
                var transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
                var gameOverScene:SKScene = GameScene(size: self.size)
                self.view?.presentScene(gameOverScene, transition: transition)
                
            })
            alien.runAction(bringUpScene)
        }
    }
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval){
        lastYieldTimeInterval += timeSinceLastUpdate
        if(lastYieldTimeInterval > 1){
            lastYieldTimeInterval = 0
            addAlien()
        }
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if (location.x > pixelman.position.x) {
                if(allowMovement){
                    runRight()
                    pixelman.runAction(moveToTheRight)
                   
                }
            }
            if (location.x < pixelman.position.x) {
                if(allowMovement){
                    runLeft()
                    pixelman.runAction(moveToTheLeft)
                
                }
                
               
                

        }
            
            
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        scoreLabel.text =  scoreVarInLabel + String(accessVar.gameScore)

       /* if(pixelman.position.x<20){
            pixelman.position.x = 20
        }
        if(pixelman.position.x>self.frame.width-5){
            pixelman.position.x = self.frame.width-5
        }*/
        var timeSinceLastUpdate = currentTime - lastUpdateTimerInterval
        lastUpdateTimerInterval = currentTime
        
        if(timeSinceLastUpdate > 1){
            timeSinceLastUpdate = 1/60
            lastUpdateTimerInterval = currentTime
        }
        

       updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
      
    }
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if((firstBody.categoryBitMask & heroHitCategory!) != 0 && (secondBody.categoryBitMask & alienCategory) != 0){
            
            lives--
            if(lives == 2){
                playCrashSound()
                heart3.removeFromParent()
            }
            if(lives == 1){
                playCrashSound()
                heart2.removeFromParent()
            }
            
            if(lives == 0){
            heart1.removeFromParent()
            gameOver = true
                allowMovement = false
                pixelman.removeAllActions()
                self.removeAllActions()
                removeAllActions()
                
            }
        }
    }
    
    func vecAdd(a: CGPoint, b: CGPoint) -> CGPoint{
        return CGPointMake(a.x + b.x, a.y + b.y)
    }
    func vecSub(a: CGPoint, b: CGPoint) -> CGPoint{
        return CGPointMake(a.x-b.x, a.y - b.y)
    }
    func vecMult(a:CGPoint, b:CGFloat) -> CGPoint {
        return CGPointMake(a.x * b, a.y * b)
    }
    func vecLength(a:CGPoint)->CGFloat{
        return CGFloat(sqrtf(CFloat(a.x)*CFloat(a.x) + CFloat(a.y)*CFloat(a.y)))
    }
    func vecNormalize(a: CGPoint)->CGPoint{
        var length:CGFloat = vecLength(a)
        return CGPointMake(a.x / length, a.y / length)
    }
    
    func runRight(){
        let runLookingRight = SKAction.animateWithTextures([
            SKTexture(imageNamed: "pixelsideLookingToRight"),
            SKTexture(imageNamed: "pixelsideLookingToRight2"),
            SKTexture(imageNamed: "pixelsideLookingToRight3"),
            SKTexture(imageNamed: "pixelsideLookingToRight2"),
            SKTexture(imageNamed: "pixelsideLookingToRight"),
            SKTexture(imageNamed: "pixelsideLookingToRight2"),
            SKTexture(imageNamed: "pixelsideLookingToRight3"),
            SKTexture(imageNamed: "pixelsideLookingToRight2"),
            SKTexture(imageNamed: "pixelsideLookingToRight"),
            SKTexture(imageNamed: "pixelsideLookingToRight2"),
            SKTexture(imageNamed: "pixelsideLookingToRight3"),
            SKTexture(imageNamed: "pixelsideLookingToRight3"),
            SKTexture(imageNamed: "pixelsideLookingToRight2"),
            SKTexture(imageNamed: "pixelsideLookingToRight"),
            
            
            SKTexture(imageNamed: "pixelperson"),
            
            ], timePerFrame: 0.06)
        
        if(allowMovement){

        pixelman.runAction(runLookingRight)
        }
        
    }
    
    func runLeft(){
        let runLookingLeft = SKAction.animateWithTextures([
            SKTexture(imageNamed: "pixelsideLookingToLeft"),
            SKTexture(imageNamed: "pixelsideLookingToLeft2"),
            SKTexture(imageNamed: "pixelsideLookingToLeft3"),
            SKTexture(imageNamed: "pixelsideLookingToLeft2"),
            SKTexture(imageNamed: "pixelsideLookingToLeft"),
            SKTexture(imageNamed: "pixelsideLookingToLeft2"),
            SKTexture(imageNamed: "pixelsideLookingToLeft3"),
            SKTexture(imageNamed: "pixelsideLookingToLeft2"),
            SKTexture(imageNamed: "pixelsideLookingToLeft"),
            SKTexture(imageNamed: "pixelsideLookingToLeft2"),
            SKTexture(imageNamed: "pixelsideLookingToLeft3"),
            SKTexture(imageNamed: "pixelsideLookingToLeft2"),
            SKTexture(imageNamed: "pixelsideLookingToLeft"),
            
            SKTexture(imageNamed: "pixelperson"),
            
            ], timePerFrame: 0.06)
        
        if(allowMovement){
        pixelman.runAction(runLookingLeft)
        }
    }
    func moveClouds(){
        let move1 = SKAction.moveByX(self.frame.width, y: 0, duration: cloudMove)
        let move2 = SKAction.moveByX(self.frame.width, y: 0, duration: cloudMove2)
        let move3 = SKAction.moveByX(self.frame.width, y: 0, duration: 16)
        let moveBack = SKAction.moveByX(-self.frame.width*1.5, y: 0, duration: 0)
        let m1Forever = SKAction.repeatActionForever(move1)
        let m2Forever = SKAction.repeatActionForever(move2)
        let m3Forever = SKAction.repeatActionForever(move3)
        if bool == true {
            cloud1.runAction(m1Forever)
        }
        cloud2.runAction(m2Forever)
        cloud3.runAction(m3Forever)
        
        if cloud1.position.x > self.frame.width {
            cloud1.runAction(moveBack)
        }
        if (cloud2.position.x > self.frame.width+30){
            cloud2.position.x = -150
            cloud2.runAction(moveBack)
            
        }
        if (cloud3.position.x > self.frame.width+30){
            cloud3.position.x = -250
            cloud3.runAction(moveBack)
        }
        
    }
    
    
}
