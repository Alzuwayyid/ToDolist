//
//  UIViewExtession.swift
//  Tawakkalna
//
//  Created by Aziz Dev on 24/03/2020.
//  Copyright © 2020 Aziz Dev. All rights reserved.
//

import UIKit

//MARK:- Constraint
public enum ConstraintsAnchors {
    case top(_ constant: CGFloat)
    case bottom(_ constant: CGFloat)
    case leading(_ constant: CGFloat)
    case trailing(_ constant: CGFloat)
    case sidesVertical(_ constant: CGFloat)
    case sidesHorizontal(_ constant: CGFloat)
    case all(_ constant: CGFloat)

    case height(_ constant: CGFloat)
    case width(_ constant: CGFloat)

    case centerVertical(_ constant: CGFloat)
    case centerHorizontal(_ constant: CGFloat)
    case center
}

extension UIView {

    public func setConstrint(_ anchors: [ConstraintsAnchors]){
        guard let superView = self.superview else{
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        for item in anchors {
            switch item {
            case .top(let constant):
                self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant).isActive = true
            case .bottom(let constant):
                superView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant).isActive = true
            case .leading(let constant):
                self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant).isActive = true
            case .trailing(let constant):
                superView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant).isActive = true
            case .sidesVertical(let constant):
                self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant).isActive = true
                superView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant).isActive = true
            case .sidesHorizontal(let constant):
                self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant).isActive = true
                superView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant).isActive = true
            case .all(let constant):
                self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant).isActive = true
                superView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant).isActive = true
                self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant).isActive = true
                superView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant).isActive = true

            case .height(let constant):
                self.heightAnchor.constraint(equalToConstant: constant).isActive = true
            case .width(let constant):
                self.widthAnchor.constraint(equalToConstant: constant).isActive = true
            case .centerVertical(let constant):
                self.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: constant).isActive = true
            case .centerHorizontal(let constant):
                self.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: constant).isActive = true
            case .center:
                self.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
                self.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            }
        }

    }

}

extension UIView {

    public func setCornerRadius(_ radius : CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

    public func setBorder(_ color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    public func setRoundedCorners(_ corners: UIRectCorner, radius: CGFloat, viewWidth: CGFloat){

        var frame = self.bounds
        frame.size.width = viewWidth

        let path = UIBezierPath(roundedRect: frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

public extension UIView {

    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable var ZZZviewBorderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if UIDevice.current.userInterfaceIdiom == .phone {
                layer.masksToBounds = true
                layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            }

        }
    }
    @IBInspectable var viewCornerRadiusIPad: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if UIDevice.current.userInterfaceIdiom == .pad {
              layer.masksToBounds = true
              layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
            }
        }
    }


    /// SwifterSwift: Check if view is in RTL format.
     var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }

    /// SwifterSwift: Take screenshot of view (if applicable).
     var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// SwifterSwift: Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            if UIDevice.current.userInterfaceIdiom == .phone {

            layer.shadowRadius = newValue
            }
        }
    }
    @IBInspectable var shadowRadiusIPad: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            if UIDevice.current.userInterfaceIdiom == .pad {
               layer.shadowRadius = newValue
            }
        }
    }

    /// SwifterSwift: Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
