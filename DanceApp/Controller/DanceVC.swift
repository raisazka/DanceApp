//
//  ViewController.swift
//  DanceAR
//
//  Created by Rais on 12/06/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARVideoKit
import Photos

class DanceVC: UIViewController, ARSCNViewDelegate {

    var animations = [String: CAAnimation]()
    
    var idle: Bool = true
        
    let danceNode = SCNNode()
    
    var audioSource = SCNAudioSource()
    
    var song : Song?
    
    var recorder: RecordAR?
    
    var recording = true
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var btnRecord: UIButton!
    
    @IBOutlet var sceneView: ARSCNView!
       
    @IBOutlet weak var btnStartDancing: UIButton!
    
    let recordingQueue = DispatchQueue(label: "recordingThread", attributes: .concurrent)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        recorder = RecordAR(ARSceneKit: sceneView)
        
        recorder?.contentMode = .aspectFill
        
        recorder?.inputViewOrientations = [.landscapeLeft, .landscapeRight, .portrait]
        
        recorder?.deleteCacheWhenExported = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
        recorder?.prepare(configuration)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)

            if let hitResult = result.first {
                loadAnimations(position: SCNVector3(hitResult.worldTransform.columns.3.x,
                                                    hitResult.worldTransform.columns.3.y,
                                                    hitResult.worldTransform.columns.3.z))
                setupButton()
                instructionLabel.removeFromSuperview()
            }
        }
    }
    
    func setupButton() {
        btnStartDancing.isHidden = false
        btnStartDancing.layer.cornerRadius = 15
        btnRecord.isHidden = false
        btnRecord.layer.cornerRadius = 15
    }
    
    func setupAudio() {
        guard let audioSource = SCNAudioSource(fileNamed: "art.scnassets/songs/castle.mp3") else {
           return
        }
        audioSource.volume = 50
        audioSource.isPositional = true
        audioSource.shouldStream = false
        audioSource.load()
        let songPlayer = SCNAudioPlayer(source: audioSource)
        danceNode.addAudioPlayer(songPlayer)
    }
    
    @IBAction func btnStartDance(_ sender: Any) {
        if idle {
            playAnimation(key: "dancing")
            btnStartDancing.setTitle("Stop Dance", for: .normal)
            btnStartDancing.backgroundColor = UIColor.systemRed
            setupAudio()
        } else {
            stopAnimation(key: "dancing")
            btnStartDancing.setTitle("Start Dance", for: .normal)
            btnStartDancing.backgroundColor = UIColor.systemGreen
            danceNode.removeAllAudioPlayers()
        }
        idle = !idle
    }
    
    func loadAnimations(position: SCNVector3) {
        let idleScene = SCNScene(named: "art.scnassets/dance/idleFixed.dae")!
        
        for child in idleScene.rootNode.childNodes {
            danceNode.addChildNode(child)
        }
        
        danceNode.position = position
        danceNode.scale = SCNVector3(0.005, 0.005, 0.005)
        sceneView.scene.rootNode.addChildNode(danceNode)
        
        loadAnimation(withKey: "dancing", sceneName: "art.scnassets/dance/sambaFixed", animationIdentifier: "sambaFixed-1")
    }
    
    func loadAnimation(withKey: String, sceneName: String, animationIdentifier: String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            animationObject.repeatCount = .greatestFiniteMagnitude
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            animations[withKey] = animationObject
        }
    }
    
    func playAnimation(key: String) {
      sceneView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
    }

    func stopAnimation(key: String) {
      sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }

    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials.first?.diffuse.contents = UIImage(named: "art.scnassets/dance.png")
        
        let planeNode = SCNNode(geometry: plane)
        
         let x = CGFloat(planeAnchor.center.x)
         let y = CGFloat(planeAnchor.center.y)
         let z = CGFloat(planeAnchor.center.z)
         planeNode.position = SCNVector3(x,y,z)
         planeNode.eulerAngles.x = -.pi / 2
        
         DispatchQueue.main.async {
            self.instructionLabel.text = "Touch the Plane to Spawn The Dancer!"
            self.instructionLabel.backgroundColor = UIColor.systemBlue
         }
        
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SongDetailVC {
            destVC.theSong = song
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        
        if recorder?.status == .recording {
            recorder?.stopAndExport()
        }
        
        recorder?.prepare(ARWorldTrackingConfiguration())
        
        recorder?.rest()
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - ARSCNViewDelegate
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    fileprivate func exportMessage(success: Bool, status: PHAuthorizationStatus) {
        if success {
            let alert = UIAlertController(title: "Video Saved", message: "Your Dance is successfully saved to your camera roll!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Awesome", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if status == .denied || status == .notDetermined || status == .restricted {
           let errorView = UIAlertController(title: "😅", message: "Please allow access to the photo library in order to save this media file.", preferredStyle: .alert)
            let settingsBtn = UIAlertAction(title: "Open Settings", style: .cancel) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
                    }
                }
            }
            errorView.addAction(UIAlertAction(title: "Later", style: UIAlertAction.Style.default, handler: {
                (UIAlertAction)in
            }))
            errorView.addAction(settingsBtn)
            self.present(errorView, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Exporting Failed", message: "There was an error while exporting your media file.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func recordAction(_ sender: UIButton) {
        if recorder?.status == .readyToRecord {
            btnRecord.setTitle("Stop", for: .normal)
            btnRecord.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
            recordingQueue.async {
                self.recorder?.record()
            }
        } else if recorder?.status == .recording {
            btnRecord.setTitle("Start Recording", for: .normal)
            btnRecord.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            self.recorder?.stop() { path in
                self.recorder?.export(video: path) { saved, status in
                    DispatchQueue.main.async {
                        self.exportMessage(success: saved, status: status)
                    }
                }
            }
        }
    }
    
}

