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

    var painter: BaseBrush?
    
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    
    var drawingStateChangedBlock: ((state: DrawingState) -> ())?
    
    private var realImage: UIImage?    
    
    private var drawingState: DrawingState!
    
    override init() {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - public methods
    
    func undo() {
        undoManager?.undo()
    }
    
    func redo() {
        undoManager?.redo()
    }
    
    // MARK: - touches methods
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let painter = self.painter {
            painter.lastPoint = nil
            
            painter.beginPoint = touches.anyObject()!.locationInView(self)
            painter.endPoint = painter.beginPoint
            
            self.drawingState = .Began
            self.drawingImage()
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let painter = self.painter {
            painter.endPoint = touches.anyObject()!.locationInView(self)
            
            self.drawingState = .Moved
            self.drawingImage()
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        if let painter = self.painter {
            painter.endPoint = nil
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if let painter = self.painter {
            painter.endPoint = touches.anyObject()!.locationInView(self)
            
            self.drawingState = .Ended
            
            self.drawingImage()
        }
    }
    
    // MARK: - drawing
    
    private func drawingImage() {
        if let painter = self.painter {
            // hook
            if let drawingStateChangedBlock = self.drawingStateChangedBlock {
                drawingStateChangedBlock(state: self.drawingState)
            }
            
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
            
            painter.strokeWidth = self.strokeWidth
            painter.drawInContext(context);
            CGContextStrokePath(context)
            
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .Ended || painter.supportedContinuousDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            self.image = previewImage;
            
            painter.lastPoint = painter.endPoint
        }
    }
}
