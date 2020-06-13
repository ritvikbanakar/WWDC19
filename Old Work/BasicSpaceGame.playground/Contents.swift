import PlaygroundSupport
import SpriteKit

//: Todo List
//: * Ship Movement
//: * Satalite
//: * `Coding`

//: Links
//: [Apple is Dope As Hell](https://apple.com)

class GameScene: SKScene, SKPhysicsContactDelegate{
    let ship = SKSpriteNode(imageNamed: "Triangle.png")
    let trash1 = SKSpriteNode(imageNamed: "Trash1.png")
    let trash2 = SKSpriteNode(imageNamed: "Trash2.png")
    let trash3 = SKSpriteNode(imageNamed: "Trash3.png")
    
    let swipeUp = UISwipeGestureRecognizer();
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        // makes sure that neither the trash or the ship can fly outta the game
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame);
        
        self.physicsBody?.collisionBitMask = 0b0001
        self.physicsBody?.categoryBitMask = 0b0001
        self.physicsWorld.contactDelegate = self
        
        ship.position = CGPoint(x: 200, y:100)
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.size)
        ship.physicsBody?.allowsRotation = false
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.collisionBitMask = 0b0001
        ship.physicsBody?.categoryBitMask = 0b001
        
        self.addChild(ship)
       
        enemySetUp()
    }
    
    func enemySetUp()
    {
        let randomInt = Int.random(in: 0..<3)
        let width = Int(frame.size.width)
        let height = Int(frame.size.height)
        let randomX = Int.random(in: 220..<width-15)
        let randomY = Int.random(in: 120..<height-15)
        var currentTrash =  SKSpriteNode(imageNamed: "")
        if randomInt == 0
        {
            currentTrash = trash1
            
        } else if randomInt == 1
        {
            currentTrash = trash2
        } else
        {
            currentTrash = trash3
        }
        currentTrash.position = CGPoint(x:randomX, y:randomY)
        currentTrash.physicsBody = SKPhysicsBody(rectangleOf: trash1.size)
        currentTrash.physicsBody?.allowsRotation = false
        currentTrash.physicsBody?.isDynamic = true
        
        currentTrash.physicsBody?.collisionBitMask = 0b0010
        currentTrash.physicsBody?.categoryBitMask = 0b0010
        currentTrash.physicsBody?.contactTestBitMask = 0b0010
        
        self.addChild(currentTrash)
        
        swipeUp.addTarget(self, action: #selector(self.swipedUp(sender:)))
        swipeUp.direction = .up
        self.view?.addGestureRecognizer(swipeUp)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let location = touches.first?.location(in: self)
        {
            if(location.x > ship.position.x)
            {
                ship.physicsBody?.applyImpulse(CGVector(dx: 2.0, dy: 0))
            } else
            {
                ship.physicsBody?.applyImpulse(CGVector(dx: -2.0, dy: 0))
            }
        }
    }
    
    @objc func swipedUp(sender: UISwipeGestureRecognizer)
    {
        print("swipe")
        // Create a new bullet everytime the user swipes up
        let bullet = SKShapeNode(circleOfRadius: 1.0)
        bullet.fillColor = UIColor.red
        
        bullet.position.x = ship.position.x
        bullet.position.y = ship.position.y + 10
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 1.0)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.velocity = CGVector(dx: (ship.physicsBody?.velocity.dx)!, dy: 100)
        
        bullet.physicsBody?.restitution = 0.999
        
        //We set the collisionBitMask to be different from the edge of the scene so that it passes through it.
        bullet.physicsBody?.collisionBitMask = 0b0010
        bullet.physicsBody?.categoryBitMask = 0b0010
        bullet.physicsBody?.contactTestBitMask = 0b0010
        
        //This gives every laser added to the scene a name property so that we can find them all later in the didFinishUpdate step.
        bullet.name = "bullet"
        
        self.addChild(bullet)
    }
    
    
    //This function runs after every frame has been shown on the screen.
    override func didFinishUpdate() {
        
        //This code repeats for every laser sprite that was added to the scene.
        self.enumerateChildNodes(withName: "bullet"){
            (node,stop) in
            
            //For every laser, figure out if it is still visible in the scene.
            if(!self.scene!.frame.contains(node.position)){
                
                //If the laser is not visible, remove it from the scene.
                node.removeFromParent()
                print("bullet removed")
               
            }
            
        }
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Create variables to represent the two bodies that contact each other.
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        //If the collisionBitMask values are the same, and the collisionBitMask is 0b0010, it means that a laser has hit the enemy.
        
        if((bodyA.collisionBitMask == bodyB.collisionBitMask) && (bodyA.collisionBitMask == 0b0010) ){
            
            print("a bullet has hit the enemy!")
            bodyA.node?.removeFromParent()
            bodyB.node?.removeFromParent()
            
        }
        
    }
}


let scene = GameScene(size:CGSize(width:400,height:400))
let view = SKView(frame:CGRect(x:0,y:0,width:400,height:400))
scene.backgroundColor = UIColor(red: 109/255.0, green: 118/255.0, blue: 200/255.0, alpha: 1.0)
view.presentScene(scene)
PlaygroundPage.current.liveView = view


