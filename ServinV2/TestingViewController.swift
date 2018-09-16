//
//  TestingViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-09-11.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class TestingViewController : UIViewController {
    
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        let progress = 0.8
        
        let progressView = UIView.init(frame: CGRect.init(x: 50.0, y: 70.0, width: progress * 20.0, height: 20.0))
        progressView.backgroundColor = UIColor.black
        
        progressView.clipsToBounds = true
        
        let starPath = drawStarBezier(x: 10.0, y: 10.0, radius: 5.0, sides: 5, pointyness: 2.0)
        
        
        
        let layer = CAShapeLayer.init()
        layer.path = starPath.cgPath
        
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.blackFontColor.withAlphaComponent(0.8).cgColor
        layer.lineWidth = 1.0
        
        progressView.layer.mask = layer
        
        self.view.addSubview(progressView)
        
        
    }
    
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(Double.pi) * a/180
        return b
    }
    
    func polygonPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(a: 360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(a: adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(a: adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1;
        }
        return points
    }
    
    func starPath(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat, startAngle:CGFloat=0) -> CGPath {
        let adjustment = startAngle + CGFloat(360/sides/2)
        let path = CGMutablePath.init()
        let points = polygonPointArray(sides: sides,x: x,y: y,radius: radius, adjustment: startAngle)
        let cpg = points[0]
        let points2 = polygonPointArray(sides: sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
        var i = 0
        path.move(to: CGPoint(x:cpg.x,y:cpg.y))
        for p in points {
            path.addLine(to: CGPoint(x:points2[i].x, y:points2[i].y))
            path.addLine(to: CGPoint(x:p.x, y:p.y))
            i += 1
        }
        path.closeSubpath()
        return path
    }
    
    func drawStarBezier(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat) -> UIBezierPath {
        
        let startAngle = CGFloat(-1*(360/sides/4)) //start the star off rotated left a quarter of the angle of the sides so that its bottom points appear flat (at least for 5 sided stars)
        let path = starPath(x: x, y: y, radius: radius, sides: sides, pointyness: pointyness, startAngle: startAngle)
        let bez = UIBezierPath(cgPath: path)
        return bez
    }
    
    
}
