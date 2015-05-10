import SpriteKit

class Game: GameScene {
  let level: Level
  let player: SKEmitterNode

  override init(size: CGSize) {
    level = Level(radius: 500)
    player = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("Particle", ofType: "sks")!) as! SKEmitterNode

    super.init(size: size)

    backgroundColor = SKColor.blackColor()

    physicsWorld.gravity = CGVector.downVector

    level.position.y = -(UIScreen.mainScreen().bounds.height / 2)

    player.position.x = 200
    player.targetNode = world
    player.physicsBody = SKPhysicsBody(circleOfRadius: 1)
    player.physicsBody?.linearDamping = 0
    player.physicsBody?.collisionBitMask = 0
//    player.physicsBody?.affectedByGravity = false
    player.physicsBody?.allowsRotation = false

    player.physicsBody?.applyImpulse(CGVector.rightVector * 100)

    addEntity(level)
    addEntity(player)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func updateWithDeltaTime(dt: CFTimeInterval) {
    player.physicsBody?.applyForce(CGVector.rightVector * 0.001)

    camera.position.x = player.position.x + 100

    if touching {
      player.physicsBody?.applyForce(CGVector.upVector * CGFloat(dt) * 3)
    }

    level.updateWithDeltaTime(dt)
  }
}