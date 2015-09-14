//
//  EraserBrush.swift
//  DrawingBoard
//
//  Created by 张奥 on 15/3/19.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class EraserBrush: PencilBrush {
    
    override func drawInContext(context: CGContextRef) {
        CGContextSetBlendMode(context, CGBlendMode.Clear)
        
        super.drawInContext(context)
    }
}
