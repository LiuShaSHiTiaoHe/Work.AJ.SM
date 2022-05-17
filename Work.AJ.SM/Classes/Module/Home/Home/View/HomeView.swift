//
//  HomeView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/6.
//

import UIKit

let HomeViewSectionHeaderIdentifier = "HomeViewSectionHeaderIdentifier"

protocol HomeViewDelegate: NSObjectProtocol {
    func chooseUnit()
    func selectModule(_ module: HomePageModule)
}

class HomeView: BaseView {

    weak var delegate: HomeViewDelegate?
    // MARK: - Privates
    private var advertisement: [AdsModel] = []
    private var notice: [NoticeModel] = []
    private var functionModule: [HomePageFunctionModule] = []

    // MARK: - Functions
    func updateTitle() {
        if let unitID = Defaults.currentUnitID {
            headerView.updateTitle(unitName: HomeRepository.shared.getUnitName(unitID: unitID))
        }
    }

    func reloadView() {
        collectionView.reloadData()
        collectionView.mj_header?.endRefreshing()
    }

    func updateAdsAndNotices(_ ads: [AdsModel], _ notices: [NoticeModel]) {
        advertisement.removeAll()
        notice.removeAll()
        advertisement.append(contentsOf: ads)
        notice.append(contentsOf: notices)
        reloadView()
    }

    func updateHomeFunctions(_ functionModules: [HomePageFunctionModule]) {
        updateTitle()
        functionModule.removeAll()
        functionModule.append(contentsOf: functionModules)
    }

    // MARK: -
    override func initData() {
        headerView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func initializeView() {
        addSubview(headerView)
        addSubview(collectionView)

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
        addGradientLayer()
    }

    lazy var headerView: HomeNaviHeaderView = {
        let view = HomeNaviHeaderView.init()
        return view
    }()

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: kMargin / 2, left: kMargin / 2, bottom: kMargin / 2, right: kMargin / 2)
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

extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeModuleCellIdentifier, for: indexPath) as? HomeModuleCell else {
            return UICollectionViewCell()
        }
        cell.initData(functionModule[indexPath.row])
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functionModule.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeViewSectionHeaderIdentifier, for: indexPath) as? HomeHeaderView else {
            return UICollectionReusableView()
        }
        header.initData(ads: advertisement, notice: notice)
        return header
    }
}

extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let module = functionModule[indexPath.row]
        if let homePageModule: HomePageModule = HomePageModule.init(rawValue: module.name) {
            delegate?.selectModule(homePageModule)
        }

    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: frame.width, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (frame.width - kMargin * 2) / 2, height: (frame.width - kMargin * 2) / 4.5)
    }
}

extension HomeView: HomeNaviHeaderViewDelegate {
    func chooseUnit() {
        delegate?.chooseUnit()
    }
}
