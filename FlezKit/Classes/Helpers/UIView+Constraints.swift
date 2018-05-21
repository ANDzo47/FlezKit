//
//  UIView+Constraints.swift
//  FlezKit
//
//  Created by Andres Rizzo on 13/5/18.
//

import Foundation
import UIKit

//FIXME: Cambiar los textos explicativos a ingles
internal extension UIView {
    
    /// Este método alinea la view a la super view tanto de manera horizontal como vertical. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameToSuperviewBounds() {
        
        bindFrameHorizontalToSuperviewBounds()
        bindFrameVerticalToSuperviewBounds()
        
    }
    
    /// Este método alinea la view a la super view horizontalmente. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameHorizontalToSuperviewBounds() {
        bindFrameHorizontalToSuperviewBounds(0, right: 0)
    }
    
    /// Este método alinea la view a la super view horizontalmente dejando de margen a derecha el valor que se le parametriza. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameHorizontalToSuperviewBounds(_ right:CGFloat) {
        bindFrameHorizontalToSuperviewBounds(0, right: right)
    }
    
    /// Este método alinea la view a la super view horizontalmente dejando de margen a izquierda el valor que se le parametriza. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameHorizontalToSuperviewBounds(left:CGFloat) {
        bindFrameHorizontalToSuperviewBounds(left, right: 0)
    }
    
    /// Este método alinea la view a la super view tanto horizontalmente dejando de margen a derecha e izquierda con los valor que se le parametriza. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameHorizontalToSuperviewBounds(_ left:CGFloat, right:CGFloat) {
        guard superview != nil else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(left)-[self]-(right)-|", options: NSLayoutFormatOptions(),
                                                                   metrics: ["left": left, "right": right],
                                                                   views: ["self": self]))
    }
    
    /// Este método alinea la view a la super view verticalmente. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameVerticalToSuperviewBounds() {
        bindFrameVerticalToSuperviewBounds(0, down: 0)
    }
    
    /// Este método alinea la view a la super view verticalmente dejando de margen hacia abajo el valor que se le parametriza. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameVerticalToSuperviewBounds(_ down:CGFloat) {
        bindFrameVerticalToSuperviewBounds(0, down: down)
    }
    
    /// Este método alinea la view a la super view verticalmente dejando de margen hacia arriba el valor que se le parametriza. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameVerticalToSuperviewBounds(up:CGFloat) {
        bindFrameVerticalToSuperviewBounds(up, down: 0)
    }
    
    /// Este método alinea la view a la super view verticalmente dejando de margen hacia arriba y abajo los valor que se le parametrizan. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func bindFrameVerticalToSuperviewBounds(_ up:CGFloat, down:CGFloat) {
        guard superview != nil else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(up)-[self]-(down)-|", options: NSLayoutFormatOptions(),
                                                                   metrics: ["up": up, "down": down],
                                                                   views: ["self": self]))
    }
    
    /// Este método centra la view en funcion de la super view verticalmente. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func centerVerticalToSuperviewBounds() {
        
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: superview,
                           attribute: .centerY,
                           multiplier: 1, constant: 0).isActive = true
        
    }
    
    /// Este método centra la view en funcion de la super view horizontalmente. Tener en cuenta que este metodo no limpia las contraints de la view
    internal func centerHorizontalToSuperviewBounds() {
        
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: superview,
                           attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
        
    }
    
}
