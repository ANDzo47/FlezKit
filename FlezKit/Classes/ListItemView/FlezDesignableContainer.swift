//
//  FlezTestView.swift
//  FlezKit
//
//  Created by Andres Rizzo on 19/5/18.
//

import Foundation
import UIKit

@IBDesignable class FlezDesignableContainer: UIView {
    
    @IBOutlet var containerView: UIView!
    private var vesselView: UIView?
    
    open var vessel: String?
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        xibSetup()
    }
    
    func xibSetup() {
        
        guard vesselView == nil,
            let containerView = self.containerView,
            let vesselView = loadViewFromNib() else { return }
        
        containerView.addSubview(vesselView)
        vesselView.bindFrameToSuperviewBounds()
        self.vesselView = vesselView
        
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = vessel else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
}
