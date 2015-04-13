//
//  Board.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

enum DrawingState {
    case Began, Moved, Ended
}

class Board: UIImageView {

    var brush: BaseBrush?
    
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    
    var drawingStateChangedBlock: ((state: DrawingState) -> ())?
    
    private var realImage: UIImage?    
    
    private var drawingState: DrawingState!
    
    override init(frame: CGRect) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        
        super.init(coder: aDecoder)
    }
    
    func takeImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        
        self.image?.drawInRect(self.bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: - touches methods
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let brush = self.brush {
            brush.lastPoint = nil
            
            brush.beginPoint = (touches.first as! UITouch).locationInView(self)
            brush.endPoint = brush.beginPoint
            
            self.drawingState = .Began
            self.drawingImage()
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let brush = self.brush {
            brush.endPoint = (touches.first as! UITouch).locationInView(self)
            
            self.drawingState = .Moved
            self.drawingImage()
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let brush = self.brush {
            brush.endPoint = (touches.first as! UITouch).locationInView(self)
            
            self.drawingState = .Ended
            
            self.drawingImage()
        }
    }
    
    // MARK: - drawing
    
    private func drawingImage() {
        if let brush = self.brush {
            // hook
            if let drawingStateChangedBlock = self.drawingStateChangedBlock {
                drawingStateChangedBlock(state: self.drawingState)
            }

            UIGraphicsBeginImageContext(self.bounds.size)
            
            let context = UIGraphicsGetCurrentContext()
            
            UIColor.clearColor().setFill()
            UIRectFill(self.bounds)
            
            CGContextSetLineCap(context, kCGLineCapRound)
            CGContextSetLineWidth(context, self.strokeWidth)
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor)
            
            if let realImage = self.realImage {
                realImage.drawInRect(self.bounds)
            }
            
            brush.strokeWidth = self.strokeWidth
            brush.drawInContext(context)
            CGContextStrokePath(context)
            
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .Ended || brush.supportedContinuousDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            self.image = previewImage
            
            brush.lastPoint = brush.endPoint
        }
    }
}
