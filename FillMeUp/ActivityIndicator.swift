//
//  ActivityIndictor.swift
//  FillMeUp
//
//  Created by Varun Rathi on 23/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicator: NSObject {
    
    public static let shared : ActivityIndicator = ActivityIndicator()
    var indicatorView : NVActivityIndicatorView?
    
    public func startLoader(on view:UIView){
        
        if  let appDelegate = UIApplication.shared.delegate{
            
            if  let window = appDelegate.window
            {
                let width:CGFloat = window!.bounds.size.width
                let height:CGFloat = window!.bounds.size.height
                
                indicatorView  = NVActivityIndicatorView(frame: CGRect(x: (width - AppTheme.kIndicatorWidth)/2
                    , y: (height - AppTheme.kIndicatorHeight)/2, width:AppTheme.kIndicatorWidth , height: AppTheme.kIndicatorHeight))
                indicatorView?.type = NVActivityIndicatorType.squareSpin
                indicatorView?.color = AppTheme.kActivityIndColor
                
                indicatorView?.startAnimating()
                view.addSubview(indicatorView!)
                
            }
        }
        
    }
    
    public func stopLoader(){
        if let loaderView = indicatorView{
            loaderView.removeFromSuperview()
        }
    }
}

