//
//  Board.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class Board: UIImageView {

    var painter: BaseBrush
    
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    
    private var realImage: UIImage?
    
    enum TouchState {
        case Began, Moved, Ended
    }
    
    private var touchState: TouchState!
    
    override init() {
        painter = PencilBrush()
        strokeColor = UIColor.blackColor()
        strokeWidth = 1
        
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        painter = PencilBrush()
        strokeColor = UIColor.blackColor()
        strokeWidth = 1
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - touches methods
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.painter.lastPoint = nil
        
        self.painter.beginPoint = touches.anyObject()!.locationInView(self)
        self.painter.endPoint = self.painter.beginPoint
        
        self.touchState = .Began
        drawingImage()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        self.painter.endPoint = touches.anyObject()!.locationInView(self)
        
        self.touchState = .Moved
        drawingImage()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.painter.endPoint = nil
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.painter.endPoint = touches.anyObject()!.locationInView(self)
        
        self.touchState = .Ended
        
        drawingImage()
    }
    
    // MARK: - drawing
    
    func drawingImage() {
        UIGraphicsBeginImageContext(self.bounds.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        self.backgroundColor!.setFill()
        UIRectFill(self.bounds)
        
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, self.strokeWidth)
        CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor)
        
        if let realImage = self.realImage {
            realImage.drawInRect(self.bounds)
        }
        
        painter.drawInContext(context);
        CGContextStrokePath(context)
        
        let previewImage = UIGraphicsGetImageFromCurrentImageContext()
        if self.touchState == .Ended || painter.supportedContinuousDrawing() {
            self.realImage = previewImage
        }
        
        UIGraphicsEndImageContext()
        
        self.image = previewImage;
        
        self.painter.lastPoint = self.painter.endPoint
    }
}
