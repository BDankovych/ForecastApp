

import UIKit

@IBDesignable
class GradientBaseView: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.clear {
        didSet {
            createGradient()
        }
    }
    @IBInspectable var bottomColor: UIColor = UIColor.clear {
        didSet {
            createGradient()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    private func createGradient() {
        gradientLayer.removeFromSuperlayer()
        backgroundColor = .clear
        gradientLayer.frame = self.bounds
        clipsToBounds = true
        gradientLayer.colors = [topColor, bottomColor].map{$0.cgColor}
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint (x: 0.5, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
