//
//  ViewController.swift
//  day4-ar_earth
//
//  Created by 齐典 on 11/24/19.
//  Copyright © 2019 齐典. All rights reserved.
// https://www.youtube.com/redirect?redir_token=w657IU3zT4YpHnhSpF1VYLIOjiB8MTU3NDcwOTk5MkAxNTc0NjIzNTky&q=https%3A%2F%2Fgithub.com%2Fbrianadvent%2F3DEarthBeyondTheBasics&v=mkD5Jw-bLLs&event=video_description

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate { // ARSCNViewDelegate render node ancher

    @IBOutlet var sceneView: ARSCNView!
    
    // plane surfaces to place the 3d object on top
    // light estimatation to make 3d object behave accordingly to external light
    
    var planeGeometry:SCNPlane!
    let planeIdentifiers = (UUID)()
    var anchors = [ARAnchor]() // real world position that can be used to place object in our AR scene
    var sceneLight:SCNLight!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self // access importing delegate functions
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene() // set to the main scene
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.autoenablesDefaultLighting = false
        
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3Make(0, 10, 2)

        sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration() // not enable plane detection by default
        configuration.planeDetection = .horizontal // just enable --- to get data
        configuration.isLightEstimationEnabled = true // to get data to estimate lighting

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        
        /*
        // hit test --- hit results
        // search for AR ancher corr. to a point in scenekit view
        let hitResults = sceneView.hitTest(location!, types: .featurePoint)
        
        if let hitTestResult = hitResults.first {
            let transform = hitTestResult.worldTransform
            let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            let newEarth = EarthNode()
            newEarth.position = position
            
            sceneView.scene.rootNode.addChildNode(newEarth)
        }
         */
        
        addNodeAtLocation(location: location!)
    }
    
    // MARK: - ARSCNViewDelegate
    
    // ctsly updates e.g., light
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let estimate = self.sceneView.session.currentFrame?.lightEstimate {
            sceneLight.intensity = estimate.ambientIntensity
        }
    }
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node:SCNNode?
        
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
            planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            
            let planeNode = SCNNode(geometry: planeGeometry)
            // need pos in 3d space
            // vertical : so y coord is 0
            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            // rotate the node by 90 deg around x axis
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            updateMaterial()
            
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
        }
     
        return node
    }
    
    // move along space -- get updates using anchor and renders
    // only update geometry
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            // if the anchors arr contains planeAnchor
            if anchors.contains(planeAnchor) {
                if node.childNodes.count > 0 {
                    // plane node in area of this planeAnchor
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                    
                    // change geometry of the plane
                    if let plane = planeNode.geometry as? SCNPlane {
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.height = CGFloat(planeAnchor.extent.z)
                        updateMaterial()
                    }
                }
            }
        }
    }
    
    func updateMaterial() {
        let material = self.planeGeometry.materials.first!
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
    }
    
    
    func addNodeAtLocation(location:CGPoint) {
        guard anchors.count > 0 else { print("anchors are not created yet"); return }
        
        // perform hit test
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent) // extent: can touch an area that the visual repre has not reached
        
        if hitResults.count > 0 {
            let result = hitResults.first!
            let newLocation = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y + 0.15, result.worldTransform.columns.3.z) // 4 by 4 matrix, 3 for 4th colum
            
            let earthNode = EarthNode()
            earthNode.position = newLocation
            
            sceneView.scene.rootNode.addChildNode(earthNode)
        }
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
