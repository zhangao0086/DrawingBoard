//
//  ViewController.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var board: Board!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIToolbar!
    
    @IBOutlet var topViewConstraintY: NSLayoutConstraint!
    @IBOutlet var bottomViewConstraintBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.board.drawingStateChangedBlock = {(state: DrawingState) -> () in
            if state == .Began {
                self.topViewConstraintY.constant = -self.topView.frame.size.height
                self.bottomViewConstraintBottom.constant = -self.bottomView.frame.size.height
                UIView.beginAnimations(nil, context: nil)
                
                self.topView.layoutIfNeeded()
                self.bottomView.layoutIfNeeded()
                
                UIView.commitAnimations()
            } else if state == .Ended {
                self.topViewConstraintY.constant = 0
                self.bottomViewConstraintBottom.constant = 0
                UIView.beginAnimations(nil, context: nil)
                
                self.topView.layoutIfNeeded()
                self.bottomView.layoutIfNeeded()
                
                UIView.commitAnimations()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func switchBrush(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.board.painter = PencilBrush()
        case 1:
            self.board.painter = LineBrush()
        case 2:
            self.board.painter = DashLineBrush()
        case 3:
            self.board.painter = RectangleBrush()
        case 4:
            self.board.painter = EllipseBrush()
        case 5:
            self.board.painter = EraserBrush()
        default:
            assert(false, "")
        }
    }
}

