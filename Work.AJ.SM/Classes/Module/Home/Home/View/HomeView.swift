//
//  HomeView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/6.
//

import UIKit

let HomeViewSectionHeaderIdentifier = "HomeViewSectionHeaderIdentifier"

class HomeView: BaseView {

    func updateTitle() {
        if let unitID = Defaults.currentUnitID {
            headerView.updateTitle(unitName: HomeRepository.shared.getUnitName(unitID: unitID))
        }
    }
    
    func reloadView() {
        collectionView.reloadData()
        collectionView.mj_header?.endRefreshing()
    }
    
    override func initData() {
        headerView.delegate = self
    }
    
    override func initializeView() {
        self.addSubview(headerView)
        self.addSubview(collectionView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(kOriginTitleAndStateHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
            make.top.equalTo(headerView.snp.bottom)
        }

    }

    override func layoutSubviews() {
        addlayer()
    }
    
    lazy var headerView: HomeNaviHeaderView = {
        let view = HomeNaviHeaderView.init()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: kMargin/2, left: kMargin/2, bottom: kMargin/2, right: kMargin/2)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        let c = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        c.alwaysBounceVertical = true
        c.backgroundColor = UIColor.clear
        c.register(HomeModuleCell.self, forCellWithReuseIdentifier: HomeModuleCellIdentifier)
        c.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeViewSectionHeaderIdentifier)
        return c
    }()
}


extension HomeView: HomeNaviHeaderViewDelegate {
    func chooseUnit() {
        let vc = SelectHouseViewController()
        vc.hidesBottomBarWhenPushed = true
        UIViewController.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
