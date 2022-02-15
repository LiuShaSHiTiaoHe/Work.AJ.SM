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
    private var functionModules: [HomePageFunctionModule] = []
    
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
        c.register(HomeModuleCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderIdentifier)
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    override func initUI() {
        addlayer()
        view.addSubview(headerView)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.mj_header = refreshHeader
        
        
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
    
    private func initData() {
        HomeRepository.shared.allUnits { [weak self] modules in
            guard let `self` = self else { return }
            self.functionModules.removeAll()
            self.functionModules.append(contentsOf: modules)
            self.collectionView.reloadData()
            self.collectionView.mj_header?.endRefreshing()
        }
        if let unitID = Defaults.currentUnitID {
            headerView.updateTitle(unitName: HomeRepository.shared.getUnitName(unitID: unitID))
        }
    }
    
    override func headerRefresh() {
        initData()
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? HomeModuleCell else { return UICollectionViewCell() }
        cell.initData(functionModules[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functionModules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.sectionHeaderIdentifier, for: indexPath) as? HomeHeaderView else { return UICollectionReusableView() }
        header.initData(ads: [], notice: [])
        return header
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 260)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.frame.width - kMargin*2)/2, height: (view.frame.width - kMargin*2)/4 )
    }
}
