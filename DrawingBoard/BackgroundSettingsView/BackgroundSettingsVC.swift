//
//  BackgroundSettingsView.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-3-29.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class BackgroundSettingsVC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var backgroundImageChangedBlock: ((backgroundImage: UIImage) -> Void)?
    var backgroundColorChangedBlock: ((backgroundColor: UIColor) -> Void)?
    
    @IBOutlet private var colorPicker: RGBColorPicker!
    
    lazy private var pickerController: UIImagePickerController = {
        [unowned self] in
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        return pickerController
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.colorPicker.colorChangedBlock = {
            [unowned self] (color: UIColor) in
            if let backgroundColorChangedBlock = self.backgroundColorChangedBlock {
                backgroundColorChangedBlock(backgroundColor: color)
            }
        }
    }
    
    func setBackgroundColor(color: UIColor) {
        self.colorPicker.setCurrentColor(color)
    }
    
    @IBAction func pickImage() {
        self.presentViewController(self.pickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let backgroundImageChangedBlock = self.backgroundImageChangedBlock {
            backgroundImageChangedBlock(backgroundImage: image)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UINavigationControllerDelegate Methods
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
    }
}