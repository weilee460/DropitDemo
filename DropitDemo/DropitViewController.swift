//
//  DropitViewController.swift
//  DropitDemo
//
//  Created by ying on 16/3/3.
//  Copyright © 2016年 ying. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var gameView: BezierPathsView!
    

    
    /* notice this error
    //In below, it has error. because gameView has not initialized.
    var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: gameView)
    */
    //solve upside problem.
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedDynamicAnimator.delegate = self
        return lazilyCreatedDynamicAnimator
    }()
    
    var dropitBehavior = DropitBehavior()
    
    //Add attachment behavior
    var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil { //add by myself, not the same with Stanford lecture
                animator.removeBehavior(attachment!)
                gameView.setPath(nil, named: PathName.Attachment)
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment?.action = { [unowned self] in
                    if let attachedView = self.attachment?.items.first as? UIView
                    {
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachedView.center)
                        self.gameView.setPath(path, named: PathName.Attachment)
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropitBehavior)
    }
    
    struct PathName {
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let barrierSize = dropSize
        let barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width / 2, y: gameView.bounds.midY - barrierSize.height / 2)
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropitBehavior.addBarrier(path, name: PathName.MiddleBarrier)
        gameView.setPath(path, named: PathName.MiddleBarrier)
    }
    
    //animator delegate
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    
    var dropsPerRow = 10
    
    var dropSize: CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    
    @IBAction func grabDrop(sender: UIPanGestureRecognizer) {
        
        let gesturePoint = sender.locationInView(gameView)
        
        switch sender.state {
        case .Began:
            if let viewToAttachTo = lastDroppedView
            {
                attachment = UIAttachmentBehavior(item: viewToAttachTo, attachedToAnchor: gesturePoint)
                lastDroppedView = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            attachment = nil
        default: break
        }
        
    }
    
    var lastDroppedView: UIView?
    
    func drop()
    {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        lastDroppedView = dropView
        
        dropitBehavior.addDrop(dropView)
    }
    
    func removeCompletedRow()
    {
        var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        repeat
        //do
        {
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropsFound = [UIView]()
            var rowIsComplete = true
            for _ in 0 ..< dropsPerRow
            {
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil)
                {
                    if hitView.superview == gameView
                    {
                        dropsFound.append(hitView)
                    }
                    else
                    {
                        rowIsComplete = false
                    }
                }
                dropFrame.origin.x += dropSize.width
            }
            if rowIsComplete {
                dropsToRemove += dropsFound
            }
        } while (dropsToRemove.count == 0 && dropFrame.origin.y > 0)
        
        for drop in dropsToRemove {
            dropitBehavior.removeDrop(drop)
        }
        
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
