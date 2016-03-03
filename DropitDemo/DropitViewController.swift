//
//  DropitViewController.swift
//  DropitDemo
//
//  Created by ying on 16/3/3.
//  Copyright © 2016年 ying. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController {

    @IBOutlet weak var gameView: UIView!
    
    //Add gravity
    let gravity = UIGravityBehavior()
    
    /* notice this error
    //In below, it has error. because gameView has not initialized.
    var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: gameView)
    */
    //solve upside problem.
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        return lazilyCreatedDynamicAnimator
    }()
    
    //As same reason.
    lazy var collider: UICollisionBehavior = {
        let lazilyCratedCollider = UICollisionBehavior()
        lazilyCratedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCratedCollider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add gravity
        animator.addBehavior(gravity)
        //add collider
        animator.addBehavior(collider)
    }
    
    
    var dropsPerRow = 10
    
    var dropSize: CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop()
    {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        gameView.addSubview(dropView)
        //add gravity
        gravity.addItem(dropView)
        //add collider
        collider.addItem(dropView)
    }

}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        //create a random float
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 5 {
            case 0: return UIColor.greenColor()
            case 1: return UIColor.blueColor()
            case 2: return UIColor.orangeColor()
            case 3: return UIColor.redColor()
            case 4: return UIColor.purpleColor()
            default: return UIColor.blackColor()
        }
    }
}
