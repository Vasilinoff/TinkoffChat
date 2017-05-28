//
//  AnimationViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 28.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
    var rootLayer:CALayer = CALayer()
    let emitter = CAEmitterLayer()
    var pointTap: CGPoint?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPressRecognizer)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func longPressed(gesture: UITapGestureRecognizer)  {
        //createFireWorks()
        if gesture.state == .began {
            print("start")
            //CGPoint point = [recognizer locationInView:recognizer.view];
            pointTap = gesture.location(in: gesture.view)
            DispatchQueue.main.async {
                self.createEmitter()
            }
        }
        
        if gesture.state == .changed {
            print("changed")
            DispatchQueue.main.async {
                self.pointTap = gesture.location(in: gesture.view)
                self.createEmitter()
            }
        }
        
        if gesture.state == .ended {
            print("ended")
            DispatchQueue.main.async {
                self.stopEmitter()
            }
        }
    }
    
    func createEmitter() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let cell = CAEmitterCell()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        
        emitter.emitterShape = kCAEmitterLayerCircle
        //emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
        emitter.emitterPosition = pointTap!
        
        emitter.emitterSize = rect.size
        cell.contentsScale = 8
        cell.birthRate = 20
        cell.lifetime = 1
        cell.velocity = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 0.5
        cell.spinRange = 1.2
        cell.scaleRange = -0.05
        cell.contents = UIImage(named: "shit")?.cgImage
        //
        
        emitter.emitterCells = [cell]
    }
    
    func stopEmitter() {
        emitter.removeFromSuperlayer()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
