//
//  FlezListItemView.swift
//  FlezKit
//
//  Created by Andres Rizzo on 13/5/18.
//

import UIKit
import QuartzCore


@IBDesignable class FlezBorderedView: UIView {
    
    private var shadowView: UIView? = nil

    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = borderRadius
            layer.masksToBounds = borderRadius > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            updateShadowView()
        }
    }

    @IBInspectable var shadowOpacity: CGFloat = 0 {
        didSet {
            updateShadowView()
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        didSet {
            updateShadowView()
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            updateShadowView()
        }
    }

    // Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateShadowView()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        updateShadowView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateShadowView()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateShadowView()
    }
    
    fileprivate func updateShadowView() {

        addShadowView()
        self.layoutIfNeeded()

    }

    fileprivate func addShadowView() {

        if let shadowView = self.shadowView {
            shadowView.removeFromSuperview()
            self.shadowView = nil
        }
        let shadowView = UIView()
        self.shadowView = shadowView

        shadowView.clipsToBounds = false
        shadowView.backgroundColor = self.backgroundColor
        shadowView.layer.cornerRadius = borderRadius
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOffset = shadowOffset
        shadowView.layer.shadowOpacity = Float(shadowOpacity)
        shadowView.layer.shadowColor = shadowColor?.cgColor
        
        if let shadowView = self.shadowView,
            let superview = self.superview,
            !superview.subviews.contains(shadowView) {
        
            superview.addSubview(shadowView)
            superview.sendSubviewToBack(shadowView)
            
            #if !TARGET_INTERFACE_BUILDER
                // this code will run in the app itself
                shadowView.translatesAutoresizingMaskIntoConstraints = false
                
                let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self.shadowView, attribute: .width, multiplier: 1, constant: 0.0)
                let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self.shadowView, attribute: .height, multiplier: 1, constant: 0.0)
                let centerHorizontal = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.shadowView, attribute: .centerY, multiplier: 1, constant: 0.0)
                let centerVertical = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.shadowView, attribute: .centerX, multiplier: 1, constant: 0.0)
                
                NSLayoutConstraint.activate([widthConstraint, heightConstraint, centerHorizontal, centerVertical])
            #else
                // this code will execute only in IB
                self.addObserver(self, forKeyPath: "bounds", options: [], context: nil)
                self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
                
                updateShadowFrame()
            #endif
            
        }
       
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" || keyPath == "frame" {
            updateShadowFrame()
        }
    }
    
    fileprivate func updateShadowFrame() {
    
        shadowView?.frame = self.frame
        shadowView?.bounds = self.bounds
        
    }

}

enum FlezListItemStyle {
    case image
    case checkbox
}

@IBDesignable class FlezListItemView: FlezBorderedView {

    var containerStackView: UIStackView?
    var textLabel: UILabel?
    
//    var style: FlezListItemStyle?
    
    // Text inspectable Section
    @IBInspectable public var text: String = "" {
        didSet {
            updateContent()
        }
    }
    
    // StackView inspectable Section
    @IBInspectable public var layoutHorizontalMargin: CGPoint = CGPoint.init(x: 8, y: 8) {
        didSet {
            updateContent()
        }
    }
    
    @IBInspectable public var layoutVerticalMargin: CGPoint = CGPoint.init(x: 8, y: 8) {
        didSet {
            updateContent()
        }
    }
    
    @IBInspectable public var layoutSpacing: CGFloat = 10.0 {
        didSet {
            updateContent()
        }
    }
    
    // Image inspectable Section
    @IBInspectable public var imageName: String? = nil {
        didSet {
            updateContent()
        }
    }
    
    @IBInspectable public var imageSize: CGSize = CGSize.zero {
        didSet {
            updateContent()
        }
    }
    
    // Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupView()
    }
    
    // Setup Methods
    fileprivate func setupView() {
        
        let containerStackView = getContainerStackView()
        containerStackView.addArrangedSubview(getLabel())
        
        updateContent()
        
        self.updateConstraints()
        self.layoutIfNeeded()
        
    }
    
    fileprivate func getContainerStackView() -> UIStackView {
        
        if let olderStackView = self.containerStackView {
            olderStackView.removeFromSuperview()
            self.containerStackView = nil
        }
        let containerStackView = UIStackView()
        self.containerStackView = containerStackView
        self.addSubview(containerStackView)
        containerStackView.bindFrameVerticalToSuperviewBounds(layoutVerticalMargin.x, down: layoutVerticalMargin.y)
        containerStackView.bindFrameHorizontalToSuperviewBounds(layoutHorizontalMargin.x, right: layoutHorizontalMargin.y)
        return containerStackView
        
    }
    
    fileprivate func getLabel() -> UILabel {
        
        if let olderLabel = self.textLabel {
            olderLabel.removeFromSuperview()
            self.textLabel = nil
        }
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        self.textLabel = textLabel
        
        return textLabel
        
    }
    
    public func updateContent() {
        
        updateText()
        updateSpacing()
        
    }
    
    private func updateText() {
        guard let label = self.textLabel else { return }
        label.text = text
    }
    
    private func updateSpacing() {
        guard let containerStackView = self.containerStackView else { return }
        containerStackView.spacing = layoutSpacing
    }
    
}
