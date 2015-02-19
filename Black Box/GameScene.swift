//
//  GameScene.swift
//  Black Box
//
//  Created by Jason Duffy on 12/28/14.
//  Copyright (c) 2014 Peapod Media, llc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let game = Game()
    
    func addEntryPoint(number: Int) {
        let input = EntryPoint.entryPoint(number, imageNamed: "Hit")
        switch number {
        case 1...8:
            input.position = CGPoint(x: 5, y: 689 - (number * 76))
        case 9...16:
            input.position = CGPoint(x: 81 + ((number - 9) * 76), y: 5)
        case 17...24:
            input.position = CGPoint(x: 689, y: 689 - ((25 - number) * 76))
        case 25...32:
            input.position = CGPoint(x: 81 + ((32 - number) * 76), y: 689)
        default:
            input.position = CGPoint(x: 0, y: 0)
        }
        input.anchorPoint = CGPoint(x: 0, y: 0)
        input.hidden = true
        addChild(input)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "blackboxboard")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(background)
        
        for i in 1...32 {
            addEntryPoint(i)
        }
        
        //TODO: real ball hiding
        game.placeAtColumn(1, andRow: 1)
        game.placeAtColumn(1, andRow: 3)
        game.placeAtColumn(7, andRow: 7)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            println("location: (\(location.x),\(location.y))")
            
            // do some stuff
            if let entryPoint = self.nodeAtPoint(location) as? EntryPoint {
                println(entryPoint.name!)
                entryPoint.hidden = false
                switch game.guess(entryPoint.number) {
                case .Some(.Hit):
                    entryPoint.texture = SKTexture(imageNamed: "Hit")
                case .Some(.Detour(let exitPoint)):
                    let exitPoint = self.childNodeWithName("Entry\(exitPoint)") as EntryPoint
                    entryPoint.texture = SKTexture(imageNamed: "Detour")
                    exitPoint.texture = SKTexture(imageNamed: "Detour")
                    exitPoint.hidden = false
                case .Some(.Reflection):
                    entryPoint.texture = SKTexture(imageNamed: "Reflection")
                case .None:
                    entryPoint.hidden = true
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
