//
//  UIView+Instance.swift
//  FlezKit
//
//  Created by Andres Rizzo on 13/5/18.
//

import Foundation

internal protocol FlezInstantiableView { }

internal extension FlezInstantiableView where Self: UIView {
    
    /// Returns a UIView from nib with the same name as the class
    static func loadView() -> Self? {
        
        let className = String(describing: self)
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: className, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else { return nil }
        return view
        
    }
    
}

@IBDesignable
open class FlezVesselView: UIView {
    
    private var contentView: UIView?
    open var vessel: String?
    //
    //    public override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        initialSetup()
    //    }
    //
    //    public required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        initialSetup()
    //    }
    //
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = vessel else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

//    private func initialSetup() {
//        if let vessel = vessel,
//            subviews.count == 0 {
//            
//            let bundle = Bundle(for: type(of:FlezListItemView()))
//            let nib = UINib(nibName: vessel, bundle: bundle)
//            
//            // Assumes UIView is top level and only object in CustomView.xib file
//            if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
//                self.addSubview(view)
//                view.bindFrameToSuperviewBounds()
//            }
//            
//            
//            
//            
//        }
//    }
    
}
