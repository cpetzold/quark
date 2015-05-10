import SpriteKit

extension SKNode {
  var positionInScene: CGPoint? {
    get {
      if let parent = parent {
        return scene?.convertPoint(position, fromNode: parent)
      }
      return nil
    }
  }
}

class Level: SKNode {
  let radius: Double
  let firstHalf: SKShapeNode
  let secondHalf: SKShapeNode

  var circumference: Double {
    get {
      return 2.0 * M_PI * radius
    }
  }

  init(radius: Double) {
    self.radius = radius

    let halfWidth = CGFloat(M_PI * radius)

    firstHalf = SKShapeNode(rect: CGRect(x: 0, y: 0, width: halfWidth, height: 100))
    firstHalf.strokeColor = SKColor.redColor()

    secondHalf = SKShapeNode(rect: CGRect(x: 0, y: 0, width: halfWidth, height: 100))
    secondHalf.position.x += halfWidth
    secondHalf.strokeColor = SKColor.blueColor()

    super.init()

    addChild(firstHalf)
    addChild(secondHalf)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


class GameScene: SKScene {
  var lastUpdateTimeInterval: CFTimeInterval?
  let world: SKNode
  let level: Level
  let camera: SKNode
  let player: SKEmitterNode

  let enemy: SKShapeNode

  var touching: Bool = false

  override init(size: CGSize) {
    world = SKNode()
    camera = SKNode()
    level = Level(radius: 1000)
    player = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("Particle", ofType: "sks")!) as! SKEmitterNode

    enemy = SKShapeNode(circleOfRadius: 6)

    super.init(size: size)

//    physicsWorld.gravity = CGVector.zeroVector

    anchorPoint = CGPoint(x: 0.5, y: 0.5)

    world.addChild(level)
    world.addChild(camera)

    level.position = CGPoint(x: 0, y: -50)

    let screen = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100))
    world.addChild(screen)

    enemy.physicsBody = SKPhysicsBody(circleOfRadius: 5)

    addChild(world)

    player.position = CGPoint(x: -200, y: 0)
    player.physicsBody = SKPhysicsBody(circleOfRadius: 1)
    player.targetNode = self
//    player.physicsBody?.collisionBitMask = 0

    world.addChild(player)

    level.addChild(enemy)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMoveToView(view: SKView) {
    backgroundColor = UIColor.blackColor()
    enemy.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0))

  }

  override func didSimulatePhysics() {
    if let cameraPosInScene = camera.positionInScene {
      camera.parent?.position -= cameraPosInScene
    }
  }

  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    touching = true
  }

  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    touching = false
  }

  override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
    touching = false
  }

  func updateWithDeltaTime(dt: CFTimeInterval) {
//    camera.position = player.position

    level.position.offset(dx: -2, dy: 0)

    if touching {
      player.physicsBody?.applyForce(CGVector(dx: 0, dy: 0.5))
    }

//    enemy.position.offset(dx: -1, dy: 0)

    let left: CGFloat = -50.0
    let c = CGFloat(level.circumference)


    let leftHalf = level.firstHalf.position.x < level.secondHalf.position.x ? level.firstHalf : level.secondHalf
    let rightHalf = leftHalf == level.firstHalf ? level.secondHalf : level.firstHalf

    if (enemy.physicsBody?.velocity.dx < 0 && enemy.position.x < leftHalf.position.x - 1) {
      enemy.position.x += c
    } else if (enemy.physicsBody?.velocity.dx > 0 && enemy.position.x > rightHalf.position.x + 1) {
      enemy.position.x -= c
    }

    if (level.position.x + level.firstHalf.position.x < left && level.secondHalf.position.x < level.firstHalf.position.x) {
      level.secondHalf.position.x += c
//      if (enemy.position.x < level.firstHalf.position.x) {
//        enemy.position.x += c
//      }
    }

    if (level.position.x + level.secondHalf.position.x < left && level.firstHalf.position.x < level.secondHalf.position.x) {
      level.firstHalf.position.x += c
//      if (enemy.position.x < level.secondHalf.position.x) {
//        enemy.position.x += c
//      }
    }
  }

  override func update(currentTime: CFTimeInterval) {
    var dt: CFTimeInterval = currentTime
    if let luti = lastUpdateTimeInterval {
      dt = currentTime - luti
    }
    lastUpdateTimeInterval = currentTime
    updateWithDeltaTime(dt)
  }


}
