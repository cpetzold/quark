import SpriteKit

class Level: SKNode {
  let radius: Double
  let firstHalf: SKShapeNode
  let secondHalf: SKShapeNode

  var obstacles: SKNode = SKNode()

  var circumference: CGFloat {
    get {
      return CGFloat(2.0 * M_PI * radius)
    }
  }

  init(radius: Double) {
    self.radius = radius

    let c = CGFloat(2.0 * M_PI * radius)
    let halfRect = CGRect(x: 0, y: 0, width: c / 2, height: UIScreen.mainScreen().bounds.size.height)

    firstHalf = SKShapeNode(rect: halfRect)
    firstHalf.strokeColor = SKColor.blueColor()

    secondHalf = SKShapeNode(rect: halfRect)
    secondHalf.position.x = c / 2
    secondHalf.strokeColor = SKColor.redColor()

    super.init()

    for i in 0...10 {
      let obstacle = SKShapeNode(circleOfRadius: 4)
      obstacle.lineWidth = 0
      obstacle.fillColor = UIColor.whiteColor()

      obstacle.position = CGPoint(x: random() % Int(circumference), y: random() % Int(UIScreen.mainScreen().bounds.size.height))
      obstacle.physicsBody = SKPhysicsBody(circleOfRadius: 4)
      obstacle.physicsBody?.affectedByGravity = false
      obstacle.physicsBody?.linearDamping = 0
      let v = CGVector(dx: (CGFloat(random()) % 1000.0) - 500, dy: 0)
//      obstacle.physicsBody?.applyImpulse(v)
      obstacle.physicsBody?.velocity = v
      obstacles.addChild(obstacle)
    }

    addChild(obstacles)
    addChild(firstHalf)
    addChild(secondHalf)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateWithDeltaTime(dt: CFTimeInterval) {
    let world = parent!
    let halfScreen = UIScreen.mainScreen().bounds.width / 2

    if (world.position.x + halfScreen + firstHalf.position.x < 0 && secondHalf.position.x < firstHalf.position.x) {
      secondHalf.position.x += circumference
    } else if (world.position.x + halfScreen + secondHalf.position.x < 0 && firstHalf.position.x < secondHalf.position.x) {
      firstHalf.position.x += circumference
    }

    // Update obstacles
    let leftHalf = firstHalf.position.x < secondHalf.position.x ? firstHalf : secondHalf
    let rightHalf = leftHalf == firstHalf ? secondHalf : firstHalf

    for obstacle in obstacles.children as! [SKNode] {
      if (obstacle.physicsBody?.velocity.dx < 0 && obstacle.position.x < leftHalf.position.x) {
        obstacle.position.x += circumference
      } else if (obstacle.physicsBody?.velocity.dx > 0 && obstacle.position.x > rightHalf.position.x + (circumference / 2)) {
        obstacle.position.x -= circumference
      }
    }
  }
}