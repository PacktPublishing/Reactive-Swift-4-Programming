

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
