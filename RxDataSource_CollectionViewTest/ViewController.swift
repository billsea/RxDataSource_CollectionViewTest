//
//  ViewController.swift
//  RxDataSource_CollectionViewTest
//
//  Created by Loud on 12/11/18.
//  Copyright © 2018 William Seaman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NumberCell : UICollectionViewCell {
  @IBOutlet weak var value: UILabel!
  
}

//Need to add this number section view to work with configureSupplementaryView
class NumberSectionView : UICollectionReusableView {
  @IBOutlet weak var value: UILabel!
}

class ViewController: UIViewController {

  @IBOutlet weak var testCollectionView: UICollectionView!
  var disposeBag = DisposeBag()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Double>>(
      configureCell: { (_, cv, indexPath, element) -> NumberCell in
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NumberCell
        cell.value?.text = "\(element) @ row \(indexPath.row)"
        cell.backgroundColor = UIColor.lightGray
        return cell
    },
      configureSupplementaryView: { (ds ,cv, kind, ip) in
        let section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Section", for: ip) as! NumberSectionView
        section.value!.text = "\(ds[ip.section].model)"
        return section
    })
    
    let items = Observable.just([
      SectionModel(model: "First section", items: [
        1.0,
        2.0,
        3.0
        ]),
      SectionModel(model: "Second section", items: [
        1.0,
        2.0,
        3.0
        ]),
      SectionModel(model: "Third section", items: [
        1.0,
        2.0,
        3.0
        ])
      ])
    
    
    items
      .bind(to: testCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    testCollectionView.rx
      .itemSelected
      .map { indexPath in
        return (indexPath, dataSource[indexPath])
      }
      .subscribe(onNext: { pair in
        //DefaultWireframe.presentAlert("Tapped `\(pair.1)` @ \(pair.0)")
      })
      .disposed(by: disposeBag)
    
//    testCollectionView.rx
//      .setDelegate(self)
//      .disposed(by: disposeBag)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

