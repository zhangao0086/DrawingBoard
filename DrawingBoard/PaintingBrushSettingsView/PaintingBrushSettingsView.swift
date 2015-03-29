//
//  PaintingBrushSettingsView.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-3-28.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit


class PaintingBrushSettingsView : UIView {
    
    var strokeWidthChangedBlock: ((strokeWidth: CGFloat) -> Void)?
    var strokeColorChangedBlock: ((strokeColor: UIColor) -> Void)?
    
    @IBOutlet private var strokeWidthSlider: UISlider!
    @IBOutlet private var strokeColorPreview: UIView!
    @IBOutlet private var colorPicker: RGBColorPicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.strokeColorPreview.layer.borderColor = UIColor.blackColor().CGColor
        self.strokeColorPreview.layer.borderWidth = 1
        
        self.colorPicker.colorChangedBlock = {
            [unowned self] (color: UIColor) in
            
            self.strokeColorPreview.backgroundColor = color
            if let strokeColorChangedBlock = self.strokeColorChangedBlock {
                strokeColorChangedBlock(strokeColor: color)
            }
        }
        
        self.strokeWidthSlider.addTarget(self, action: "strokeWidthChanged:", forControlEvents:.ValueChanged)
    }
    
    func setBackgroundColor(color: UIColor) {
        self.strokeColorPreview.backgroundColor = color
        self.colorPicker.setCurrentColor(color)
    }
    
    func strokeWidthChanged(slider: UISlider) {
        if let strokeWidthChangedBlock = self.strokeWidthChangedBlock {
            strokeWidthChangedBlock(strokeWidth: CGFloat(slider.value))
        }
    }
}