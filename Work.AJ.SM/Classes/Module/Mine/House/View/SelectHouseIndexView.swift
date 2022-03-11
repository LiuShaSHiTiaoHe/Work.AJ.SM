//
//  SelectHouseIndexView.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/11.
//

import UIKit

class SelectHouseIndexView: BaseView {

    var locations: [String] = [] {
        didSet {
            locationIndexCollectionView.reloadData()
        }
    }
    
    override func initData() {
        locationIndexCollectionView.delegate = self
        locationIndexCollectionView.dataSource = self
    }
    
    override func initializeView() {
        self.backgroundColor = R.color.backgroundColor()
        
        self.addSubview(tipsContentView)
        tipsContentView.addSubview(tipsLabel)
        self.addSubview(locationIndexCollectionView)
        
        tipsContentView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(30)
        }
        
        locationIndexCollectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tipsContentView.snp.bottom)
        }
    }
    
    lazy var tipsContentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.font = k14Font
        view.textColor = R.color.secondtextColor()
        view.text = "当前已选择"
        return view
    }()
    
    
    lazy var locationIndexCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: kMargin/2, bottom: 0, right: kMargin/4)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .horizontal
        let c = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        c.alwaysBounceHorizontal = true
        c.showsHorizontalScrollIndicator = false
        c.backgroundColor = R.color.whiteColor()
        c.register(SelectHouseLocationIndexCell.self, forCellWithReuseIdentifier: SelectHouseLocationIndexCellIdetifier)
        return c
    }()

}


extension SelectHouseIndexView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectHouseLocationIndexCellIdetifier, for: indexPath) as? SelectHouseLocationIndexCell else { return UICollectionViewCell() }
        if indexPath.row % 2 > 0 {
            cell.locationNameLabel.text = ">"
        }else{
            let location = locations[indexPath.row/2]
            cell.locationNameLabel.text = location
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if locations.count  > 0 {
            return locations.count * 2 - 1
        }
        return locations.count
    }
}

extension SelectHouseIndexView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension SelectHouseIndexView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row % 2 > 0 {
            return .init(width: 20, height: 30)
        }
        let location = locations[indexPath.row/2]
        let width = location.jk.singleLineSize(font: k14SysFont)
        return .init(width: width.width, height: 30)
    }
}

