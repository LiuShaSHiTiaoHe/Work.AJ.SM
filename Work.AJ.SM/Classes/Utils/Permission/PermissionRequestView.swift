//
//  PermissionRequestView.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/9/19.
//

import UIKit
import PermissionsKit
import CameraPermission
import BluetoothPermission
import MicrophonePermission
import PhotoLibraryPermission

class PermissionRequestView: UIView {
    private let permission = [Permission.bluetooth, Permission.camera, Permission.microphone, Permission.photoLibrary]

    lazy var listView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.register(PermissionCell.self, forCellReuseIdentifier: PermissionCellIdentifier)
        return view
    }()
    
    func initializeView() {
        self.backgroundColor = .clear
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kMargin)
        }
    }
    
    func initData() {
        listView.dataSource = self
        listView.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PermissionRequestView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        permission.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PermissionCellIdentifier, for: indexPath) as! PermissionCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.permission = permission[indexPath.row]
        return cell
    }
    
    
}

