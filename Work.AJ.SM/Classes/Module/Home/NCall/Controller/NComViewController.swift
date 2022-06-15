//
//  NComViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/12.
//

import UIKit

class NComViewController: BaseViewController {

    private var dataSource:[NComDTU] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.tableView.mj_header?.beginRefreshing()
    }
    
    override func initData() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ncomdevicecell")
        contentView.headerView.rightButton.addTarget(self, action: #selector(go2RecordView), for: .touchUpInside)
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        contentView.tableView.mj_header = refreshHeader()
    }

    override func headerRefresh() {
        loadAllDevice()
    }
    
    // MARK: - Functions
    func loadAllDevice() {
        HomeRepository.shared.allNComDeviceInfo { [weak self] devices in
            guard let self = self else { return }
            if devices.isEmpty {
                self.showNoDataView(.nodata, self.contentView.headerView)
            }else{
                self.hideNoDataView()
                self.dataSource = devices
                self.reloadTableView()
            }
        }
    }
        
    
    @objc func go2RecordView(){
        navigationController?.pushViewController(NComRecordViewController(), animated: true)
    }
    
    func reloadTableView() {
        contentView.tableView.reloadData()
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var contentView: NComView = {
        let view = NComView()
        return view
    }()
    
}

extension NComViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ncomdevicecell", for: indexPath)
        let device = dataSource[indexPath.row]
        let signalImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        if let sig = device.signalIntensity {
            switch sig {
            case "0":
                signalImageView.image = R.image.cell_icon_wifi_0()
            case "1":
                signalImageView.image = R.image.cell_icon_wifi_1()
            case "2":
                signalImageView.image = R.image.cell_icon_wifi_2()
            case "3":
                signalImageView.image = R.image.cell_icon_wifi_3()
            case "4":
                signalImageView.image = R.image.cell_icon_wifi_4()
            default:
                signalImageView.image = R.image.cell_icon_wifi_0()
            }
        }else{
            signalImageView.image = R.image.cell_icon_wifi_0()
        }
        if let gap = device.gap, gap == 1 {
            cell.textLabel?.textColor = UIColor.init(hex: "409EFF")
        }else{
            cell.textLabel?.textColor = UIColor.init(hex: "F56C6C")
        }
        cell.accessoryView = signalImageView
        cell.textLabel?.text = device.lockName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let deviceInfo = dataSource[indexPath.row]
        if let lockMac = deviceInfo.lockMac {
//            let macString = lockMac.components(separatedBy: ":").joined(separator: "")
//            let vc = AudioChatViewController.init(startCall: macString)
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
        }
    }
}
