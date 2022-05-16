//
//  IndoorCallElevatorViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/16.
//

import UIKit
import SVProgressHUD

class IndoorCallElevatorViewController: BaseViewController {

    lazy var contentView: IndoorCallElevatorView = {
        let view = IndoorCallElevatorView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        // Do any additional setup after loading the view.
    }

    override func initData() {
        contentView.delegate = self
        contentView.headerView.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }

    // MARK: - refreshView
    private func refreshView() {
        contentView.refreshKit()
    }

    private func updateResultView(_ flag: Bool) {
        contentView.updateResultView(flag)
    }

    override func initUI() {
        view.backgroundColor = R.color.backgroundColor()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension IndoorCallElevatorViewController: IndoorCallElevatorViewDelegate {

    func callElevatorAction(_ isUp: Bool) {
        let direction = isUp ? "2" : "1"
        SVProgressHUD.show()
        HomeRepository.shared.callElevatorViaMobile(direction: direction) { errorMsg in
            if errorMsg.isEmpty {
                SVProgressHUD.showSuccess(withStatus: "呼梯成功")
                self.updateResultView(true)
            } else {
                SVProgressHUD.showError(withStatus: errorMsg)
                self.updateResultView(false)
            }
        }
    }
}
