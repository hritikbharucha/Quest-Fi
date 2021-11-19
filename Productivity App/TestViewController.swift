//
//  TestViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 10/30/21.
//

import UIKit
import SceneKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        sceneView.scene = SCNScene(named: "assets.xcassets/first_character.dae")
        
        let node = SCNNode()
        let scene = SCNScene(named: "firstCharacter.dae")
        let nodeArray = scene?.rootNode.childNodes

        for childNode in nodeArray ?? [SCNNode]() {
          node.addChildNode(childNode as SCNNode)
        }
        
        sceneView.scene = SCNScene()
        
        sceneView.scene?.rootNode.addChildNode(node)
        
    }

}
