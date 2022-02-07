//
//  HomeViewController.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/28.
//

import UIKit

class HomeViewController: BaseViewController {

    private let cellIdentifier = "HomeModuleCell"
    private let sectionHeaderIdentifier = "HomeHeaderView"
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: kMargin/2, left: kMargin/2, bottom: kMargin/2, right: kMargin/2)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        let c = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        c.alwaysBounceVertical = true
        c.backgroundColor = R.color.contentColor()
        c.register(HomeModuleCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderIdentifier)
        c.refreshControl = UIRefreshControl()
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    override func initUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
            make.top.equalToSuperview()
        }
    }
    
    private func initData() {

    }
    

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.frame.width - kMargin*3)/4, height: (view.frame.width - kMargin*2)/4 )
    }
}
