//
//  Board.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

protocol PaintBrush {
    
    func prepareForContext(context: CGContextRef)
    
    func drawAtPoint(point: CGPoint, path: CGMutablePathRef)

//    func layerForBeginPoint(beginPoint: CGPoint, endPoint: CGPoint) -> CALayer
}

class BasePainter : NSObject, PaintBrush {
    var beginPoint: CGPoint!
    var fillColor: CGColorRef!
    var strokeColor: CGColorRef!

    func prepareForContext(context: CGContextRef) {
        // ...
    }
    
    func drawAtPoint(point: CGPoint, path: CGMutablePathRef) {
        // ...
    }
    
    func layerForBeginPoint(beginPoint: CGPoint, endPoint: CGPoint) -> CALayer {
        return CALayer()
    }
}

////////////////////////////////////////////////////////////////////

class Board: UIView {

    var painter: BasePainter {
        didSet {
            painter.strokeColor = UIColor.blackColor().CGColor
            painter.fillColor = UIColor.clearColor().CGColor
        }
    }
    
    private var endPoint: CGPoint?
//    private var lastPath: CGMutablePathRef?
    
    private var drawImage: UIImage?
    
    override init() {
        painter = LinePainter()
        
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        painter = LinePainter()
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - touches methods
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.painter.beginPoint = touches.anyObject()!.locationInView(self)
        
        drawingImage()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        endPoint = touches.anyObject()!.locationInView(self)
        
        drawingImage()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        endPoint = nil
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        endPoint = nil
        
//        if let lastPath = self.lastPath {
//            var bounds = CGPathGetBoundingBox(lastPath)
//            bounds = CGRectApplyAffineTransform(bounds, CGAffineTransformMakeScale(0, 0))
//            
//            let sublayer = CAShapeLayer()
//            sublayer.anchorPoint = CGPoint(x: 0, y: 0)
//            sublayer.strokeColor = UIColor.blackColor().CGColor
//            sublayer.fillColor = UIColor.clearColor().CGColor
//            sublayer.path = lastPath
//            sublayer.position = bounds.origin
//            sublayer.bounds = CGRect(origin: CGPointZero, size: bounds.size)
//
//            self.layer.addSublayer(sublayer)
//        }
    }
    
    // MARK: - drawing
    
    func drawingImage() {
        if let endPoint = self.endPoint {
            UIGraphicsBeginImageContext(self.bounds.size)
            let context = UIGraphicsGetCurrentContext()
            
//            let layer = painter.layerForBeginPoint(painter.beginPoint, endPoint: endPoint)
//            var bounds = CGPathGetBoundingBox(layer.path)
//            layer.bounds = CGRect(origin: CGPointZero, size: bounds.size)
//            self.layer.addSublayer(layer)
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            
            self.drawImage?.drawInRect(self.bounds)

            painter.prepareForContext(context)

            let path = CGPathCreateMutable()

            painter.drawAtPoint(endPoint, path: path)

            CGContextAddPath(context, path)
            CGContextStrokePath(context)

//            lastPath = path
            self.drawImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        if let drawImage = self.drawImage {
            self.backgroundColor = UIColor(patternImage: drawImage)
        }
    }
}
