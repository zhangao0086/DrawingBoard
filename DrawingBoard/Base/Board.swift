//
//  Board.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class Board: UIImageView {

    var painter: BaseBrush {
        didSet {
            painter.strokeColor = UIColor.blackColor().CGColor
            painter.fillColor = UIColor.clearColor().CGColor
        }
    }
    
    private var endPoint: CGPoint?
    
    private var realImage: UIImage?
    
    override init() {
        painter = LineBrush()
        
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        painter = LineBrush()
        
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
            if painter.supportedContinuousDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            self.image = previewImage;
        }
    }
}
