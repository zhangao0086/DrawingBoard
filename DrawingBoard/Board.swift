//
//  Board.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

protocol PaintBrush {
    
    func supportedContinuousDraw() -> Bool;
    
    func prepareForContext(context: CGContextRef)
    
    func drawAtPoint(point: CGPoint, path: CGMutablePathRef)
}

class BasePainter : NSObject, PaintBrush {
    var beginPoint: CGPoint!
    var fillColor: CGColorRef!
    var strokeColor: CGColorRef!

    func supportedContinuousDraw() -> Bool {
        return false
    }
    
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

class Board: UIImageView {

    var painter: BasePainter {
        didSet {
            painter.strokeColor = UIColor.blackColor().CGColor
            painter.fillColor = UIColor.clearColor().CGColor
        }
    }
    
    private var endPoint: CGPoint?
    
    private var realImage: UIImage?
    
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
    }
    
    // MARK: - drawing
    
    func drawingImage() {
        if let endPoint = self.endPoint {
            UIGraphicsBeginImageContext(self.bounds.size)
            
            let context = UIGraphicsGetCurrentContext()
            
            self.backgroundColor!.setFill()
            UIRectFill(self.bounds)
            
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            
            if let realImage = self.realImage {
                realImage.drawInRect(self.bounds)
            }

            painter.prepareForContext(context)

            let path = CGPathCreateMutable()

            painter.drawAtPoint(endPoint, path: path)

            CGContextAddPath(context, path)
            CGContextStrokePath(context)

            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if painter.supportedContinuousDraw() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            self.image = previewImage;
        }
    }
}
