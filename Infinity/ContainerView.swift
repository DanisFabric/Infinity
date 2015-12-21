//
//  ContainerView.swift
//  InfinitySample
//
//  Created by Danis on 15/12/21.
//  Copyright © 2015年 danis. All rights reserved.
//

import UIKit

enum HeaderFooterType {
    case Header
    case Footer
}

class HeaderFooterContainerView : UIView {
    
    weak var scrollView: UIScrollView?
    var type = HeaderFooterType.Header
    
    init(type: HeaderFooterType) {
        super.init(frame: CGRect())
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            view.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if type == .Header {
            let firstResponderViewController = self.firstResponderViewController()
            firstResponderViewController.automaticallyAdjustsScrollViewInsets = false
            
            if let navigationController = firstResponderViewController.navigationController {
                if firstResponderViewController.automaticallyAdjustsScrollViewInsets && navigationController.navigationBar.translucent && firstResponderViewController.edgesForExtendedLayout.contains(.Top) {
                    if let scrollView = self.scrollView {
                        scrollView.contentInset = UIEdgeInsets(top: navigationController.navigationBar.frame.origin.y + navigationController.navigationBar.frame.height, left: scrollView.contentInset.left, bottom: scrollView.contentInset.bottom, right: scrollView.contentInset.right)
                        scrollView.scrollIndicatorInsets = scrollView.contentInset
                    }
                }
            }
        }
        
    }
}

extension UIView {
    func firstResponderViewController() -> UIViewController {
        var responder = self as UIResponder
        while responder.isKindOfClass(UIView.self) {
            responder = responder.nextResponder()!
        }
        return responder as! UIViewController
    }
}

