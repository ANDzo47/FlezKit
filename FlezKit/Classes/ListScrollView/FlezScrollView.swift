//
//  FlezScrollView.swift
//  FlezKit
//
//  Created by Andres Rizzo on 22/5/18.
//

import Foundation

@IBDesignable class FlezScrollView: UIView {
    
    var mainStackView: UIStackView?
    var mainScrollView: UIScrollView?
    
    fileprivate var interfaceBuilderViews: [UIView]?
    
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
   
    // Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
        
        translatesAutoresizingMaskIntoConstraints = false
        
        initializeContainedViews()
        
        let scrollView = getScrollView()
        let stackView = getStackView()
        
        // Add Stackview into Scrollview hugging content with scroll view content size
        scrollView.addSubview(stackView)
        stackView.bindFrameToSuperviewBounds()
        make(stackView: stackView, huggingToScrollView: scrollView)
        
        // Update Interface Builder into StackView
        addContainedViews(intoStackView: stackView)
        
        // Update all layouts
        scrollView.layoutIfNeeded()
        stackView.layoutIfNeeded()
        self.layoutIfNeeded()
        
    }
    
    fileprivate func initializeContainedViews() {
        
        guard interfaceBuilderViews == nil,
            self.subviews.count > 0 else { return }
        
        interfaceBuilderViews = [UIView]()
        for view in self.subviews {
            if let mainScrollView = mainScrollView {
                if view != mainScrollView {
                    interfaceBuilderViews?.append(view)
                }
            } else {
                interfaceBuilderViews?.append(view)
            }
        }
        
    }
    
    fileprivate func make(stackView: UIStackView, huggingToScrollView scrollView: UIScrollView) {
        
        let widthConstraint = NSLayoutConstraint(item: scrollView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1, constant: 0)
        widthConstraint.priority = .required
        scrollView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: scrollView, attribute: .height, relatedBy: .equal, toItem: stackView, attribute: .height, multiplier: 1, constant: 0)
        heightConstraint.priority = .defaultLow
        scrollView.addConstraint(heightConstraint)
        
    }
    
    fileprivate func getScrollView() -> UIScrollView {
        
        if let mainScrollView = self.mainScrollView {
            mainScrollView.removeFromSuperview()
            self.mainScrollView = nil
        }
        let mainScrollView = UIScrollView()
        self.mainScrollView = mainScrollView
        
        self.addSubview(mainScrollView)
        mainScrollView.bindFrameToSuperviewBounds()
        mainScrollView.backgroundColor = UIColor.clear
        
        return mainScrollView
        
    }
    
    fileprivate func getStackView() -> UIStackView {
        
        if let mainStackView = self.mainStackView {
            mainStackView.removeFromSuperview()
            self.mainStackView = nil
        }
        let mainStackView = UIStackView()
        mainStackView.spacing = layoutSpacing
        mainStackView.axis = .vertical
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: layoutVerticalMargin.x, left: layoutHorizontalMargin.x, bottom: layoutVerticalMargin.y, right: layoutHorizontalMargin.y)
        mainStackView.backgroundColor = UIColor.clear
        self.mainStackView = mainStackView
        
        return mainStackView
        
    }
    
    fileprivate func addContainedViews(intoStackView stackView: UIStackView) {
        #if !TARGET_INTERFACE_BUILDER
            // this code will run in the app itself
            
            translatesAutoresizingMaskIntoConstraints = false
            
            if let interfaceBuilderViews = self.interfaceBuilderViews {
                for view in interfaceBuilderViews {
                    
                    view.removeFromSuperview()
                    stackView.addArrangedSubview(view)
                    
                }
            }
            
        #else

            // this code will execute only in IB
            updateFrames()
            
            self.translatesAutoresizingMaskIntoConstraints = true
            
            self.addObserver(self, forKeyPath: "bounds", options: [], context: nil)
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
            
        #endif
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" || keyPath == "frame" {
            updateFrames()
        }
    }
    
    fileprivate func updateFrames() {
        
        if let interfaceBuilderViews = self.interfaceBuilderViews,
            let stackView = self.mainStackView,
            let scrollView = self.mainScrollView {
            
            scrollView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            scrollView.bounds = self.bounds
            
            var currentVerticalPosition = layoutVerticalMargin.x
            let leftMargin = layoutHorizontalMargin.x
            let viewWidth = self.frame.size.width - layoutHorizontalMargin.x - layoutHorizontalMargin.y
            
            for view in interfaceBuilderViews {
                
                removeAutolayoutErrors(toView: view)
                
                view.frame = CGRect(x: leftMargin, y: currentVerticalPosition, width: viewWidth, height: view.frame.size.height)
                view.bounds = CGRect(x: 0, y: 0, width: viewWidth, height: view.frame.size.height)
                
                stackView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: currentVerticalPosition + view.frame.size.height + layoutVerticalMargin.y)

                currentVerticalPosition += view.frame.size.height + layoutSpacing
             
                
                
            }
            
        }
        
    }
    
    fileprivate func removeAutolayoutErrors(toView view: UIView) {
        
        if view.hasAmbiguousLayout {
            view.exerciseAmbiguityInLayout()
        }
        view.translatesAutoresizingMaskIntoConstraints = true
        
        for subview in view.subviews {
            removeAutolayoutErrors(toView: subview)
        }
        
    }
    
    public func updateContent() {
        
//        updateText()
//        updateSpacing()
        
    }
    
}

