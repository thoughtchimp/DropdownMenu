//
//  DropdownMenu.swift
//  DropdownMenu
//
//  Created by Thought Chimp on 30/05/16.
//  Copyright © 2016 ThoughtChimp. All rights reserved.
//

private let leftPadding:CGFloat = 14.0
private let buttonWidth:CGFloat = 40.0
private let cellIdentifier = "menuCell"
public typealias CompletionHandler = (() -> Void)

import UIKit

public class DropdownMenu: UIView {

    
    private var isExtraMenuVisible = false
    
    private var lable1: UILabel!
    private var lable2: UILabel!
    private var lable3: UILabel!
    private var lable4: UILabel!
    
    private var line1: UIView!
    private var line2: UIView!
    private var line3: UIView!
    private var line4: UIView!
    
    private let line1Frame = CGRect(x: 18, y: 34, width: 20.5, height: 2)
    private let line2Frame = CGRect(x: 18, y: 40.5, width: 16.5, height: 2)
    private let line3Frame = CGRect(x: 18, y: 47, width: 20.5, height: 2)
    
    private var lable1Frame = CGRect(x: 90, y: 60, width: 0, height: 21)
    private var lable2Frame = CGRect(x: 90, y: 105, width: 0, height: 21)
    private var lable3Frame = CGRect(x: 90, y: 150, width: 0, height: 21)
    private var lable4Frame = CGRect(x: 90, y: 195, width: 0, height: 21)
    
    private let menuButtonFrame =  CGRect(x: leftPadding, y: leftPadding, width: buttonWidth, height: buttonWidth)
    
    private var menuViewExtraHeight:CGFloat = 0.0
    private let menuHeight:CGFloat = 260.0
    private var heightForRowAtIndexPath: CGFloat = 45.0
    
    private var menuView:UIView!

    private var zoomCircle: RoundView!
    private var cancelButton: UIButton!
    private var moreButton: UIButton?
    
    //Constraints
   /* private var tableHeightConstraint:NSLayoutConstraint?
    private var menuTopEdgeConstraint:NSLayoutConstraint?
    private var menuHeightConstraint:NSLayoutConstraint?*/

    private struct Color {
        static let orangeColor = UIColor.orangeColor()
        static let purpleColor = UIColor(red:0.267, green:0.157, blue:0.286, alpha:1)
        static let transparentBlack = UIColor.blackColor().colorWithAlphaComponent(0.1)
    }
    
    private var screenBounds: CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    private var screenHeight: CGFloat {
        return screenBounds.height
    }
    
    private var screenWidth: CGFloat {
        return screenBounds.width
    }

    private var currentState: State = .Closed
    private var contentController: UIViewController?
    private var menuContentTableView: UITableView?

    private var textFont: UIFont?

    public enum State {
        case Shown
        case Closed
        case Displaying
    }
    
    public var textColor: UIColor?
    public var menuBackgroundColor: UIColor?
    public var enabled: Bool = true

    public var items: [DropdownMenuItem] = []

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.textFont           = UIFont(name: "HelveticaNeue-Light", size: 18)
        self.textColor           = Color.orangeColor
        self.menuBackgroundColor = Color.purpleColor
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(item1: DropdownMenuItem, item2: DropdownMenuItem, item3: DropdownMenuItem, item4: DropdownMenuItem,  otherItems: [DropdownMenuItem]?, forViewController: UIViewController) {
        self.init()
        self.backgroundColor = UIColor.clearColor()
        self.items = [item1, item2, item3, item4]
        
        if let otherItems = otherItems{
            items += otherItems
        }
        
        frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        contentController = forViewController
        contentController?.view.frame = frame
        
        let menuController = UIViewController()
        menuController.view = self
        menuController.view.hidden = true
        UIApplication.sharedApplication().delegate?.window??.rootViewController = menuController
        UIApplication.sharedApplication().delegate?.window??.insertSubview(contentController!.view, atIndex: 0)
    }
    
    //MARK: Create Subview
    private func createMenu(){
        let menuFrame = CGRect(x: 0, y: 0, width: screenWidth, height: menuHeight)
        menuView = UIView(frame: menuFrame)
        menuView.backgroundColor = menuBackgroundColor
        addSubview(menuView)
        
        menuView.clipsToBounds = true
        slideMenuView(show: false)
        
        let tableFrame =  CGRect(x: 90, y: 60, width: screenWidth-90, height: menuHeight-60)
        menuContentTableView = UITableView(frame: tableFrame)
        menuContentTableView?.scrollEnabled = false
        menuContentTableView?.delegate = self
        menuContentTableView?.dataSource = self
        menuContentTableView?.showsVerticalScrollIndicator = false
        menuContentTableView?.separatorStyle = .None
        menuContentTableView?.backgroundColor = menuBackgroundColor
        self.menuContentTableView!.hidden = true
        
        menuContentTableView?.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
//        menuContentTableView?.registerNib(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        menuView.addSubview(menuContentTableView!)
        

        //Circle zoom on tap of menu
        zoomCircle = RoundView(frame: CGRect(x: leftPadding+16, y: leftPadding+16, width: buttonWidth/2, height: buttonWidth/2))
        zoomCircle.backgroundColor = Color.transparentBlack
        zoomCircle.alpha = 0.0
        
        //Cancel Button
        cancelButton = UIButton(frame: menuButtonFrame)
        cancelButton.setImage(DropdownMenuStyleKit.imageOfCross.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: #selector(DropdownMenu.cancelTapped), forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.tintColor = textColor
        
        hideShowCanelButton(hide: true)
        
        lable1Frame.size.width = getWidthForText(0)
        
        lable1 = UILabel(frame: lable1Frame)
        lable1.text = items[0].title!.uppercaseString
        customizeLabel(lable1)
        lable1.transform = transformFromRect(lable1.frame, toRect: line1Frame)
        
        lable2Frame.size.width = getWidthForText(1)
        lable2 = UILabel(frame: lable2Frame)
        lable2.text = items[1].title!.uppercaseString
        customizeLabel(lable2)
        lable2.transform = transformFromRect(lable2.frame, toRect: line2Frame)
        
        lable3Frame.size.width = getWidthForText(2)
        lable3 = UILabel(frame: lable3Frame)
        lable3.text = items[2].title!.uppercaseString
        customizeLabel(lable3)
        lable3.transform = transformFromRect(lable3.frame, toRect: line3Frame)
        
        lable4Frame.size.width = getWidthForText(3)
        lable4 = UILabel(frame: lable4Frame)
        lable4.text = items[3].title!.uppercaseString
        customizeLabel(lable4)
        lable4.transform = transformFromRect(lable4.frame, toRect: line3Frame)
        
        menuView.addSubview(zoomCircle)
        menuView.addSubview(cancelButton)
        
        //MARK: Extra Menu Items
        if items.count>4{
            
            let extraItems = items.count-4
            menuViewExtraHeight += menuHeight + CGFloat(extraItems*45)
            
            moreButton = UIButton(frame: CGRect(x: leftPadding, y: menuHeight-40, width: 40, height: 40))
        
            moreButton?.setImage(DropdownMenuStyleKit.imageOfArrow.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
            moreButton?.tintColor = textColor!.colorWithAlphaComponent(0.7)
            moreButton?.addTarget(self, action: #selector(DropdownMenu.moreTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            moreButton?.alpha = 0.0
            menuView.addSubview(moreButton!)
        }
        
        line1 = UIView(frame: line1Frame)
        addLine(line1)
        
        line2 = UIView(frame: line2Frame)
        addLine(line2)
        
        line3 = UIView(frame: line3Frame)
        addLine(line3)
        
        line4 = UIView(frame: line3Frame)
        addLine(line4)
    }
    
    func getWidthForText(index: Int)->CGFloat{
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 21))
        lable.font = textFont
        lable.text = items[index].title!.uppercaseString
        lable.sizeToFit()
        
        return lable.frame.width
    }

    func customizeLabel(lable: UILabel){
        lable.font = textFont
        lable.textColor = textColor
        lable.alpha = 0.0
        menuView.addSubview(lable)
    }
    
    func addLine(line: UIView) {
        line.backgroundColor = textColor
        self.addSubview(line)
    }
    
    //MARK: Orientation Change
    func orientationChanged()
    {
        
        if isExtraMenuVisible {
            let containerHeight  = screenHeight
            let newHeight = menuViewExtraHeight>containerHeight ? containerHeight : menuViewExtraHeight
            var newFrame = self.menuView.frame
            newFrame.size.height = newHeight
            self.menuView.frame = newFrame
//            menuHeightConstraint?.constant = newHeight
            
            let translateY = newHeight-self.menuHeight
            let transform = CGAffineTransformMakeTranslation(0, translateY)
            self.moreButton?.transform = CGAffineTransformRotate(transform, -CGFloat(M_PI))
            self.contentController?.view!.transform = CGAffineTransformMakeTranslation(0, newHeight-64)
        }
        
    }
    
    // MARK:Animation and menu operations
    
    public func openWithCompletion(completion completion: CompletionHandler?) {
        NSNotificationCenter.defaultCenter().removeObserver(self)

        self.line1.alpha = 1.0
        self.line2.alpha = 1.0
        self.line3.alpha = 1.0
        self.line4.alpha = 1.0
        self.hidden = false

        if currentState == .Shown { return }
        contentController?.navigationController?.navigationBarHidden = true
        currentState = .Displaying
        
        UIView.animateWithDuration(0.7, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.contentController?.view!.transform = CGAffineTransformMakeTranslation(0, self.menuHeight-64)
            }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,  animations: {

            self.slideMenuView(show: true)
            }, completion: nil)
        
        UIView.animateKeyframesWithDuration(0.7, delay: 0.1, options: .CalculationModeCubic, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.3) {
                self.zoomCircle.alpha = 1.0
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5) {
                
                self.zoomCircle.transform = CGAffineTransformMakeScale(37, 37)
                self.lable4.transform = CGAffineTransformIdentity
                self.lable4.alpha = 1.0
                
                self.line4.transform = self.transformFromRect(self.line3Frame, toRect: self.lable4Frame)
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.3, animations: {
                self.line4.alpha = 0.0
                self.lable4.alpha = 1.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.15, relativeDuration: 0.5) {
                self.lable3.transform = CGAffineTransformIdentity
                self.lable3.alpha = 1.0
                
                self.line3.transform = self.transformFromRect(self.line3Frame, toRect: self.lable3Frame)
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.17, relativeDuration: 0.3, animations: {
                self.line3.alpha = 0.0
                self.lable3.alpha = 1.0
            })
            
            
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.5) {
                self.lable2.transform = CGAffineTransformIdentity
                self.lable2.alpha = 1.0
                
                self.line2.transform = self.transformFromRect(self.line2Frame, toRect: self.lable2Frame)
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.22, relativeDuration: 0.3, animations: {
                self.line2.alpha = 0.0
                self.lable2.alpha = 1.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.3, relativeDuration: 0.5) {
                self.lable1.transform = CGAffineTransformIdentity
                self.lable1.alpha = 1.0
                
                self.line1.transform = self.transformFromRect(self.line1Frame, toRect: self.lable1Frame)
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.34, relativeDuration: 0.3, animations: {
                self.line1.alpha = 0.0
                self.lable1.alpha = 1.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: {
                self.contentController?.view.alpha = 0.7
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.42, relativeDuration: 0.3) {
                self.hideShowCanelButton(hide: false)
                self.moreButton?.alpha = 1.0
                self.zoomCircle.alpha = 0.0
            }
            
        }) { (success) in
            self.menuContentTableView!.hidden = false
            self.lable1.hidden = true
            self.lable2.hidden = true
            self.lable3.hidden = true
            self.lable4.hidden = true
            self.currentState = .Shown

            completion?()
        }
    }
    
    private func slideMenuView(show show: Bool){
        if show{
            menuView.transform = CGAffineTransformIdentity
           // menuBackView.transform = CGAffineTransformIdentity
        }else{
            menuView.transform = CGAffineTransformMakeTranslation(0, -menuHeight)
            //menuBackView.transform = CGAffineTransformMakeTranslation(0, -menuHeight)
        }
    }
    
    public func closeWithCompletion(completion completion: CompletionHandler?) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DropdownMenu.orientationChanged), name: UIDeviceOrientationDidChangeNotification, object: nil)

        self.currentState = .Closed
        contentController?.navigationController?.navigationBarHidden = false

        if isExtraMenuVisible{
            isExtraMenuVisible = false
            showHideExtraMenu(false, completion: { (success) in
                self.hideMenuAnimation(completion)
            })
        }else{
            hideMenuAnimation(completion)
        }
    }
    
    func hideMenuAnimation(completion: CompletionHandler?){
        
        self.menuContentTableView!.hidden = true
        self.lable1.hidden = false
        self.lable2.hidden = false
        self.lable3.hidden = false
        self.lable4.hidden = false
//          UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: {
        UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.CurveLinear,  animations: {
            self.contentController?.view.transform = CGAffineTransformIdentity
            self.contentController?.view.alpha = 1.0

            self.slideMenuView(show: false)

            }, completion: { _ in
                self.currentState = .Closed
                self.hidden = true
                completion?()
        })
        
        
        UIView.animateKeyframesWithDuration(0.6, delay: 0.0, options: .CalculationModeCubic, animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.3) {
                self.hideShowCanelButton(hide: true)
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.6) {
                self.zoomCircle.transform = CGAffineTransformIdentity
                self.lable1.transform = self.transformFromRect(self.lable1.frame, toRect: self.line1Frame)
                self.line1.transform = CGAffineTransformIdentity
                self.zoomCircle.alpha = 1.0
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.44, relativeDuration: 0.3, animations: {
                self.line1.alpha = 1.0
                self.lable1.alpha = 0.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.6) {
                self.lable2.transform = self.transformFromRect(self.lable2.frame, toRect: self.line2Frame)
                self.line2.transform = CGAffineTransformIdentity
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.54, relativeDuration: 0.3, animations: {
                self.line2.alpha = 1.0
                self.lable2.alpha = 0.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.3, relativeDuration: 0.6) {
                self.lable3.transform = self.transformFromRect(self.lable3.frame, toRect: self.line3Frame)
                self.line3.transform = CGAffineTransformIdentity
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.64, relativeDuration: 0.3, animations: {
                self.line3.alpha = 1.0
                self.lable3.alpha = 0.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.35, relativeDuration: 0.6) {
                self.lable4.transform = self.transformFromRect(self.lable4.frame, toRect: self.line3Frame)
                self.line4.transform = CGAffineTransformIdentity
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.64, relativeDuration: 0.3, animations: {
                self.line4.alpha = 1.0
                self.lable4.alpha = 0.0
                self.zoomCircle.alpha = 0.0
                self.moreButton?.alpha = 0.0
            })
            
        }) { (success) in
        }
    }

    func showHideExtraMenu(show: Bool, completion: ((Bool) -> Void)?){
        menuContentTableView?.reloadData()

        if show{
            menuContentTableView!.scrollEnabled = true
            UIView.animateWithDuration(0.4, animations: {
                
                let containerHeight = self.screenHeight
                let newHeight = self.menuViewExtraHeight > containerHeight ?  containerHeight : self.menuViewExtraHeight
                
                var newFrame = self.menuView.frame
                newFrame.size.height = newHeight
                self.menuView.frame = newFrame
                
                var tableFrame = self.menuContentTableView!.frame
                tableFrame.size.height = newHeight-60
                self.menuContentTableView?.frame = tableFrame
//                self.menuHeightConstraint?.constant = newHeight
                
                let translateY = newHeight-self.menuHeight
                let transform = CGAffineTransformMakeTranslation(0, translateY)
                self.moreButton?.transform = CGAffineTransformRotate(transform, -CGFloat(M_PI))
                self.contentController?.view!.transform = CGAffineTransformMakeTranslation(0, newHeight-64)
                
                }, completion: completion)
        }else{
            menuContentTableView!.scrollEnabled = false
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            menuContentTableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
            
            UIView.animateWithDuration(0.3, animations: {
                
                var newFrame = self.menuView.frame
                newFrame.size.height = self.menuHeight
                self.menuView.frame = newFrame
                
                var tableFrame = self.menuContentTableView!.frame
                tableFrame.size.height = self.menuHeight-60
                self.menuContentTableView?.frame = tableFrame
//                self.menuHeightConstraint?.constant = self.menuHeight
                
                self.moreButton?.transform = CGAffineTransformIdentity
                self.contentController?.view!.transform = CGAffineTransformMakeTranslation(0, self.menuHeight-64)
                
                }, completion: completion)
        }
    }
    
    func hideShowCanelButton(hide hide: Bool) {
        if hide{
            cancelButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        }else{
            cancelButton.transform = CGAffineTransformIdentity
        }
    }
    
    //MARK: IBAction
    @IBAction func moreTapped(sender: UIButton){
        isExtraMenuVisible = !isExtraMenuVisible
        showHideExtraMenu(isExtraMenuVisible, completion: nil)
    }

    @objc private func cancelTapped(){
        closeWithCompletion(completion: nil)
    }
    
    //MARK: Utils
    func transformFromRect(from: CGRect, toRect to: CGRect) -> CGAffineTransform {
        let transform = CGAffineTransformMakeTranslation(CGRectGetMidX(to)-CGRectGetMidX(from), CGRectGetMidY(to)-CGRectGetMidY(from))
        return CGAffineTransformScale(transform, to.width/from.width, to.height/from.height)
    }
    
    /**
     Generates an Equal constraint
     - returns: `NSlayoutConstraint` an equal constraint for the specified parameters
     */
    private func getEqualConstraint(item: AnyObject, toItem: AnyObject, attribute: NSLayoutAttribute) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .Equal, toItem: toItem, attribute: attribute, multiplier: 1, constant: 0)
    }

    // MARK:Menu Interactions
    
    public func show() {
        if menuContentTableView==nil{
         createMenu()
        }
        
        if !enabled { return }

        if currentState == .Shown || currentState == .Displaying {
            closeWithCompletion(completion: nil)
        } else {
            currentState = .Displaying
            openWithCompletion(completion: nil)
        }
    }
}

extension DropdownMenu: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isExtraMenuVisible ? items.count : 4
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuTableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.titleLable.textColor = textColor
        cell.titleLable.font = textFont
        
        let mediumMenuItem: DropdownMenuItem?
            mediumMenuItem = items[indexPath.row]
            cell.titleLable.text = mediumMenuItem?.title?.uppercaseString
    
        return cell
    }
    
    //MARK: UITableViewDelegate
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedItem = items[indexPath.row]
        closeWithCompletion(completion: selectedItem.completion)
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightForRowAtIndexPath
    }
}

class DropdownMenuStyleKit : NSObject {
    
    // Cache
    struct Cache {
        static var imageOfCross: UIImage?
        static var crossTargets: [AnyObject]?
        static var imageOfArrow: UIImage?
        static var arrowTargets: [AnyObject]?
    }
    
    class func drawCross() {
        // Cross Shape Drawing
        let crossShapePath = UIBezierPath()
        crossShapePath.moveToPoint(CGPointMake(12, 28))
        crossShapePath.addLineToPoint(CGPointMake(28, 12))
        crossShapePath.moveToPoint(CGPointMake(12, 12))
        crossShapePath.addLineToPoint(CGPointMake(28, 28))
        crossShapePath.lineCapStyle = CGLineCap.Round;
        crossShapePath.lineJoinStyle = CGLineJoin.Round;
        UIColor.whiteColor().setStroke()
        crossShapePath.lineWidth = 2
        crossShapePath.stroke()
    }
    
    class func drawArrow() {
        // Arrow Shape Drawing
        let arrowShapePath = UIBezierPath()
        arrowShapePath.moveToPoint(CGPointMake(10, 15))
        arrowShapePath.addLineToPoint(CGPointMake(20, 25))
        arrowShapePath.addLineToPoint(CGPointMake(30, 15))
        arrowShapePath.lineCapStyle = CGLineCap.Round;
        arrowShapePath.lineJoinStyle = CGLineJoin.Round;
        UIColor.whiteColor().setStroke()
        arrowShapePath.lineWidth = 2
        arrowShapePath.stroke()
    }

    class var imageOfArrow: UIImage {
        if (Cache.imageOfArrow != nil) {
            return Cache.imageOfArrow!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(40, 40), false, 0)
        DropdownMenuStyleKit.drawArrow()
        Cache.imageOfArrow = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfArrow!
    }
    
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(40, 40), false, 0)
        DropdownMenuStyleKit.drawCross()
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
}

class RoundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height/2
    }
}

extension UIViewController{
    
    func addDropdownMenuNavigationBarButton(){
       
        let imageMenu = UIImage(contentsOfFile: NSBundle(forClass: DropdownMenu.self).pathForResource("ham", ofType: "png")!)
        let icon = UIBarButtonItem(image: imageMenu, style: .Plain, target: navigationController, action: #selector(self.show))
        icon.tintColor = UIColor.orangeColor()
        navigationItem.leftBarButtonItem = icon
    }
}