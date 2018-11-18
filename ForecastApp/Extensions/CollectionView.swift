
import Foundation
import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type, nibName: String? = nil) {
        let identifier = "\(cellType)"
        let cellnibName = nibName ?? "\(cellType)"
        let nib = UINib(nibName: cellnibName, bundle: nil)
        self.register(cellType, forCellWithReuseIdentifier: identifier)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func cell<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier:"\(cellType)", for: indexPath) as? T else {
            return T()
        }
        return cell
    }
    
}
