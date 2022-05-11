//
//  View + Extensions.swift
//
//
//  Created by Yuvaraj on 06/11/20.
//

import UIKit

extension UIView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    @IBInspectable public var shadowOffset: CGSize{
        get{
            return self.layer.shadowOffset
        }
        set{
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable public var shadowColor: UIColor{
        get{
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set{
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat{
        get{
            return self.layer.shadowRadius
        }
        set{
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable public var shadowOpacity: Float{
        get{
            return self.layer.shadowOpacity
        }
        set{
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat{
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    ///Sets the rotation to given degree.
    ///This also includes all the subviews.
    public func setRotationTo(degrees angleInDegrees: CGFloat) {
        let angleInRadians = angleInDegrees / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: angleInRadians)
        self.transform = rotation
    }
    
    ///Flips the view horizontally.
    ///This also includes all the subviews.
    public func flipHorizontally() {
        let transform = self.transform.scaledBy(x: -1.0, y: 1.0)
        self.transform = transform
    }
    
    ///Resets all transform applied.
    public func resetTransform() {
        self.transform = .identity
    }
    
    ///Flips the view vertically.
    ///This also includes all the subviews.
    public func flipVertically() {
        let transform = self.transform.scaledBy(x: 1.0, y: -1.0)
        self.transform = transform
    }
    
    ///Sets left, right, bottom, top contraints equal to given view.
    public func attachAllAnchors(to parentView: UIView, distance: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: distance),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: distance),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: distance),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: distance)
        ])
    }
    
    ///Sets top, bottom constraints equal to given view.
    public func attachVerticalAnchors(to parentView: UIView, distance: CGFloat = 0) {
        self.autoresizingMask = [.flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.autoresizesSubviews = true
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: distance),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: distance),
        ])
    }
    
    ///Sets left, right constraints equal to given view.
    public func attachHorizontalAnchors(to parentView: UIView, distance: CGFloat = 0) {
        self.autoresizingMask = [.flexibleWidth]
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.autoresizesSubviews = true
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: distance),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: distance)
        ])
    }
    
    ///Sets left constraint equal to given view.
    public func attachLeftAnchor(to parentView: UIView, distance: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.autoresizesSubviews = true
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: distance)
        ])
    }
    
    ///Sets right constraint equal to given view.
    public func attachRightAnchor(to parentView: UIView, distance: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.autoresizesSubviews = true
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: distance)
        ])
    }
    
    ///Sets top constraint equal to given view.
    public func attachTopAnchor(to parentView: UIView, distance: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.autoresizesSubviews = true
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: distance)
        ])
    }
    
    ///Sets bottom constraint equal to given view.
    public func attachBottomAnchor(to parentView: UIView, distance: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.autoresizesSubviews = true
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: distance)
        ])
    }
    
    ///Sets centerX constraint equal to given view.
    ///Also sets top, bottom greater than equal to given view, if height is not given.
    public func attachCenterXAnchor(to parentView: UIView, withHeight height: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.autoresizesSubviews = true
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor)
        ])
        if height == nil {
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(greaterThanOrEqualTo: parentView.leadingAnchor, constant: 0),
                self.trailingAnchor.constraint(greaterThanOrEqualTo: parentView.trailingAnchor, constant: 0)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: height!)
            ])
        }
    }
    
    ///Sets centerY constraint equal to given view.
    ///Also sets left, right greater than equal to given view, if width is not given.
    public func attachCentenYAnchor(to parentView: UIView, withWidth width: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.autoresizesSubviews = true
        parentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        ])
        if width == nil {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(greaterThanOrEqualTo: parentView.topAnchor, constant: 0),
                self.bottomAnchor.constraint(greaterThanOrEqualTo: parentView.bottomAnchor, constant: 0)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: width!)
            ])
        }
    }
    
    ///Returns subview's frame relative to given superview.
    public func convertedFrame(ofSubView subview: UIView) -> CGRect? {
        guard subview.isDescendant(of: self) else {
            return nil
        }
        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }
        var superview = subview.superview
        while superview != self {
            if let newFrame = superview?.convert(frame, to: superview?.superview) {
                frame = newFrame
            }
            if superview?.superview == nil {
                break
            } else {
                superview = superview?.superview
            }
        }
        return superview?.convert(frame, to: self)
    }
    
    ///Inserts a blurview as subview at index 0.
    public func addBlur(with style: UIBlurEffect.Style) {
        if UIAccessibility.isReduceTransparencyEnabled == false {
            self.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.insertSubview(blurEffectView, at: 0)
        }
    }
}

