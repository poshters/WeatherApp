//
//  Custom.swift
//  WeatherApp
//
//  Created by MacBook on 11/9/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

final class CustomTextField: UITextField {
    
    // MARK: - UI
    @IBInspectable var underLineWidth: CGFloat = 2.0
    @IBInspectable var underLineColor: UIColor = .black
    @IBInspectable var underLineAlphaBefore: CGFloat = 0.5
    @IBInspectable var underLineAlphaAfter: CGFloat = 1
    @IBInspectable var placeholderTextColor: UIColor = .gray
    
    // MARK: - Instance
    var animationDuration: TimeInterval = 0.35
    
    let scaleCoeff: CGFloat = 0.75
    let textInsetX: CGFloat = 1.5
    let placeholderAlphaAfter: CGFloat = 0.85
    let placeholderAlphaBefore: CGFloat = 0.5
    
    var placeholderLabel = UILabel(frame: CGRect.zero)
    var placeholderLabelMinCenter: CGFloat = 0.0
    var underlineView = UIView(frame: CGRect.zero)
    var isLifted = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawLine()
        setupObserver()
    }
    
    /// Draw under line
    func drawLine() {
        let underLine = UIView(frame: CGRect(x: 0, y: frame.size.height - underLineWidth,
                                             width: frame.size.width, height: underLineWidth))
        
        underLine.backgroundColor = underLineColor
        underLine.alpha = underLineAlphaBefore
        
        underlineView = underLine
        addSubview(underlineView)
    }
    
    /// Draw placeholder
    ///
    /// - Parameter rect: CGRect
    override func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        
        guard let font = font else {
            return
            
        }
        
        let placeholderRect = CGRect(x: rect.origin.x,
                                     y: underLineWidth,
                                     width: rect.size.width,
                                     height: font.pointSize)
        placeholderLabel = UILabel(frame: placeholderRect)
        placeholderLabel.center = CGPoint(x: placeholderLabel.center.x,
                                          y: frame.size.height - underlineView.frame.size.height -
                                            placeholderLabel.frame.size.height / 2)
        placeholderLabel.text = placeholder
        placeholder = nil
        
        placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)
        
        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.alpha = placeholderAlphaBefore
        
        placeholderLabelMinCenter = placeholderLabel.center.x * scaleCoeff
        
        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
    }
    
    /// Draw placeholder if text exist in rect
    ///
    /// - Parameter rect: CGRect
    func drawPlaceholderIfTextExistInRect(rect: CGRect) {
        guard let font = font else {
            return
        }
        
        let placeholderRect = CGRect(x: rect.origin.x,
                                     y: underLineWidth * 2,
                                     width: rect.size.width,
                                     height: font.pointSize)
        placeholderLabel = UILabel(frame: placeholderRect)
        placeholderLabel.transform = CGAffineTransform(scaleX: scaleCoeff, y: scaleCoeff)
        placeholderLabel.center = CGPoint(x: placeholderLabel.center.x * scaleCoeff,
                                          y: placeholderLabel.frame.size.height)
        placeholderLabel.text = placeholder
        placeholder = nil
        
        placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)
        
        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.alpha = placeholderAlphaAfter
        isLifted = true
        
        placeholderLabelMinCenter = placeholderLabel.center.x
        
        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
    }
    
    /// Draw text
    ///
    /// - Parameter rect: CGRect
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        
        if  placeholder != nil, let textString = text, !textString.isEmpty {
            drawPlaceholderIfTextExistInRect(rect: rect)
        }
        
        textAlignment = .left
        contentVerticalAlignment = .bottom
    }
    
    /// Text rect
    ///
    /// - Parameter bounds: CGRect
    /// - Returns: CGRect
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetForY = underLineWidth + 2.0
        textAlignment = .left
        contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: textInsetX, dy: insetForY)
    }
    
    /// Editing rect
    ///
    /// - Parameter bounds: CGRect
    /// - Returns: CGRect
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetForY = underLineWidth + 2.0
        textAlignment = .left
        contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: textInsetX, dy: insetForY)
    }
    
    /// Lift up placeholder
    private func liftUpPlaceholder() {
        let newCenterX = max(placeholderLabelMinCenter, placeholderLabel.center.x * scaleCoeff)
        let newCenter = CGPoint(x: newCenterX,
                                y: placeholderLabel.frame.size.height)
        animatePlaceholder(withNewCenter: newCenter,
                           scaleCoeff: scaleCoeff,
                           newAlpha: placeholderAlphaAfter,
                           underlineAlpha: underLineAlphaAfter,
                           isLiftedAfterFinishing: true)
    }
    
    /// Lift down placeholder if text is empty
    private func liftDownPlaceholderIfTextIsEmpty() {
        if text?.count == 0 {
            let newCenterX = min(placeholderLabelMinCenter / scaleCoeff, placeholderLabel.center.x / scaleCoeff)
            let newCenterY =
                frame.size.height - underlineView.frame.size.height - placeholderLabel.frame.size.height / 2.0 - 2.0
            let newCenter = CGPoint(x: newCenterX, y: newCenterY)
            
            animatePlaceholder(withNewCenter: newCenter,
                               scaleCoeff: 1,
                               newAlpha: placeholderAlphaBefore,
                               underlineAlpha: underLineAlphaBefore,
                               isLiftedAfterFinishing: false)
        }
    }
    
    /// Notification observer
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBeginChangeText),
                                               name: UITextField.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeText),
                                               name: UITextField.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(didEndChangingText),
                                               name: UITextField.textDidEndEditingNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UIView extension
extension UIView {
    func transform(withCoeff coeff: CGFloat, andMoveCenterToPoint center: CGPoint) {
        let transform = CGAffineTransform(scaleX: coeff, y: coeff)
        self.transform = transform
        self.center = center
    }
}

// MARK: - Notification actions
extension CustomTextField {
    @objc func didBeginChangeText() {
        if !isLifted {
            liftUpPlaceholder()
        } else {
            animateUnderline(withAlpha: underLineAlphaAfter)
        }
    }
    
    @objc func didChangeText() {
        if isLifted {
            liftDownPlaceholderIfTextIsEmpty()
        } else {
            if text?.count != 0 {
                liftUpPlaceholder()
            } else {
                animateUnderline(withAlpha: underLineAlphaBefore)
            }
        }
    }
    
    @objc func didEndChangingText() {
        liftDownPlaceholderIfTextIsEmpty()
    }
}

// MARK: - Animations
extension CustomTextField {
    func animateUnderline(withAlpha alpha: CGFloat) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.underlineView.alpha = alpha
        })
    }
    
    /// Animate placeholder
    ///
    /// - Parameters:
    ///   - newCenter: CGPoint
    ///   - scaleCoeff: CGFloat
    ///   - newAlpha: CGFloat
    ///   - underlineAlpha: CGFloat
    ///   - isLiftedAfterFinishing: Bool
    func animatePlaceholder(withNewCenter newCenter: CGPoint,
                            scaleCoeff: CGFloat,
                            newAlpha: CGFloat,
                            underlineAlpha: CGFloat,
                            isLiftedAfterFinishing: Bool) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.placeholderLabel.transform(withCoeff: scaleCoeff, andMoveCenterToPoint: newCenter)
            self.placeholderLabel.alpha = newAlpha
            self.underlineView.alpha = underlineAlpha
        }, completion: isLiftedCompletion(withNewValue: isLiftedAfterFinishing))
    }
    
    /// Is lifted completion
    ///
    /// - Parameter value: Bool
    /// - Returns: ((Bool) -> Void)?
    func isLiftedCompletion(withNewValue value: Bool) -> ((Bool) -> Void)? {
        return { (finished) in
            if finished {
                self.isLifted = value
            }
        }
    }
}
