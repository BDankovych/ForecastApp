


import UIKit

@IBDesignable
class RoundedTableView: UITableView {

    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet {
            setupUI()
        }
    }
    
    func setupUI() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
    }

}

