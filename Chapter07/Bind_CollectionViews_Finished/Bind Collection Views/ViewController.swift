

import UIKit
import RxSwift
import RxDataSources

struct SectionModel {
    let title: String
    var data: [String]
}

extension SectionModel : AnimatableSectionModelType{
    typealias Item = String
    typealias Identity = String
    
    var identity: Identity { return title }
    var items: [Item] { return data }
    
    init(original: SectionModel, items: [String]) {
        self = original
        data = items
    }
}
class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    let disposeBag = DisposeBag()
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionModel>()
    
    let data = Variable([
        SectionModel(title: "Section 0", data: ["0"])
        ])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configureCell = { _, collectionView, indexPath, title in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
            cell.titleLabel.text = title
            return cell
        }
        
        dataSource.supplementaryViewFactory = {dataSource, collectionView, kind, indexPAth in
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPAth) as! Header
            headerView.titleLabel.text = dataSource.sectionModels[indexPAth.section].title
            return headerView
        }
        
        data.asDriver()
        .drive(collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        addBarButtonItem.rx.tap
            .bind(onNext:{ [unowned self] in
                let section = self.data.value.count
                let items: [String] = {
                    var items = [String]()
                    let random = Int(arc4random_uniform(6)) + 1
                    
                    (0...random).forEach {
                        items.append("\(section)-\($0)")
                    }
                    
                    return items
                }()
                self.data.value += [SectionModel(
                    title:"Section: \(section)",
                    data: items
                    )]
            })
            .disposed(by: disposeBag)
      
    }
}
