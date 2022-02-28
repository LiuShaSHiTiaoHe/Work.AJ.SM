//
//  FaceListViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/28.
//

import UIKit

class FaceListViewController: BaseViewController {
    
    private var dataSource:[FaceModel] = []

    lazy var headerView: CommonHeaderView = {
        let view = CommonHeaderView.init()
        view.titleLabel.textColor = R.color.maintextColor()
        view.closeButton.setImage(R.image.common_back_black(), for: .normal)
        view.backgroundColor = R.color.whiteColor()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.register(FaceTableViewCell.self, forCellReuseIdentifier: FaceTableViewCellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = R.color.backgroundColor()
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("添加人脸照片", for: .normal)
        button.setTitleColor(R.color.whiteColor(), for: .normal)
        button.backgroundColor = R.color.themeColor()
        button.addTarget(self, action: #selector(addFaceImage), for: .touchUpInside)
        button.layer.cornerRadius = 20.0
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initData()
  
    }
    
    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTitleAndStateHeight)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(250)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-kMargin)
        }
        
    }
    
    func initData() {
        tableView.delegate = self
        tableView.dataSource = self
        headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        headerView.titleLabel.text = "人脸认证"
        MineRepository.shared.getFaceList { [weak self] faces in
            guard let `self` = self else { return }
            self.dataSource = faces
            self.tableView.reloadData()
        }
    }
    
    @objc
    func addFaceImage() {
        
    }
    
}
extension FaceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FaceTableViewCellIdentifier, for: indexPath) as! FaceTableViewCell
        let data = dataSource[indexPath.row]
        cell.faceData = data
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
        
}

extension FaceListViewController: FaceTableViewCellDelegate {
    func deleteFace(path: String) {
        
    }
}