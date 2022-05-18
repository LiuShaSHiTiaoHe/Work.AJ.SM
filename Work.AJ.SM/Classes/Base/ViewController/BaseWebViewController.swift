//
//  BaseWebViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import UIKit
import WebKit

enum WebViewScriptMessageHandlerName: String {
    case Header = "requestHeader"
    case Token = "requestToken"
}

class BaseWebViewController: UIViewController {
    enum URLType {
        /// 在线
        case online
        /// 本地文件
        case localFile
    }

    //MARK: - 需要加载的地址
    public var urlString: String?
    public var titleString: String? = kConstAPPNameString
    //MARK: - 加载的地址类型
    public var urlType: URLType = .online
    //MARK: - 返回或关闭Item
    fileprivate lazy var backItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
                image: R.image.common_back_white(),
                style: .plain,
                target: self,
                action: #selector(selectedToBack)
        )
        return item
    }()
    //MARK: - 关闭item
    fileprivate lazy var closeItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
                image: R.image.common_close_black(),
                style: .plain,
                target: self,
                action: #selector(selectedToClose)
        )
        item.imageInsets = UIEdgeInsets(top: 0, left: -22, bottom: 0, right: 0)
        return item
    }()

    //MARK: - WKWebView对象
    fileprivate lazy var wkWebview: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let userContentController = WKUserContentController.init()
        userContentController.add(self, name: WebViewScriptMessageHandlerName.Header.rawValue)

        let configuration = WKWebViewConfiguration.init()
        configuration.preferences = preferences
        configuration.userContentController = userContentController
        let webView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = R.color.bg()
        webView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: 1 | 4)
        webView.isMultipleTouchEnabled = true
        webView.autoresizesSubviews = true
        webView.scrollView.alwaysBounceVertical = true
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()

    //MARK: - UIProgressView进度条对象
    fileprivate lazy var progress: UIProgressView = {
        let tempProgressView = UIProgressView.init()
        tempProgressView.tintColor = R.color.themeColor()
        tempProgressView.backgroundColor = .white
        return tempProgressView
    }()

    //MARK: - UIBarButtonItem
    fileprivate func setupBarButtonItem() {
        navigationItem.leftBarButtonItems = [backItem]
    }

    //MARK: - 设置UI部分
    fileprivate func setupUI() {
        setupBarButtonItem()
        view.addSubview(wkWebview)
        view.addSubview(progress)
        progress.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(2)
            make.trailing.equalToSuperview()
        }
        wkWebview.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(progress.snp.bottom)
        }
    }

    //MARK: - 加载地址
    fileprivate func loadRequest() {
        if let urlString = urlString, let url = URL(string: urlString) {
            if urlType == .online {
                wkWebview.load(URLRequest(url: url))
            } else {
                wkWebview.loadFileURL(url, allowingReadAccessTo: url)
            }
        }
    }

    //MARK: - 添加观察者
    fileprivate func addKVOObserver() {
        wkWebview.addObserver(
                self,
                forKeyPath: "estimatedProgress",
                options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                context: nil
        )
        wkWebview.addObserver(
                self,
                forKeyPath: "canGoBack",
                options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                context: nil
        )
        wkWebview.addObserver(
                self,
                forKeyPath: "title",
                options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                context: nil
        )
    }

    //MARK: - 移除观察者,观察者的创建和移除一定要成对出现
    deinit {
        wkWebview.removeObserver(self, forKeyPath: "estimatedProgress")
        wkWebview.removeObserver(self, forKeyPath: "canGoBack")
        wkWebview.removeObserver(self, forKeyPath: "title")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.bg()
        navigationItem.title = titleString
        navigationController?.navigationBar.tintColor = R.color.whiteColor()
        setupUI()
        loadRequest()
        addKVOObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func messageToJs(_ type: WebViewScriptMessageHandlerName) {
        switch type {
        case .Header:
            break
        case .Token:
            break
        }
    }
}

//MARK: - Actions
@objc
extension BaseWebViewController {

    //MARK: - 返回按钮执行事件
    fileprivate func selectedToBack() {
        if (wkWebview.canGoBack) {
            wkWebview.goBack()
        } else {
            if let navigation = navigationController {
                navigation.setNavigationBarHidden(true, animated: false)
                navigation.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }

    //MARK: - 关闭按钮执行事件
    fileprivate func selectedToClose() {
        if let navigation = navigationController {
            navigation.setNavigationBarHidden(true, animated: false)
            navigation.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}


//MARK: - KVO
extension BaseWebViewController {
    //MARK: - 观察者的监听方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "estimatedProgress" {
            progress.alpha = 1.0
            progress.setProgress(Float(wkWebview.estimatedProgress), animated: true)
            if wkWebview.estimatedProgress >= 1 {
                UIView.animate(withDuration: 1.0, animations: {
                    self.progress.alpha = 0
                }, completion: { (finished) in
                    self.progress.setProgress(0.0, animated: false)
                })
            }
        } else if keyPath == "title" {
            navigationItem.title = wkWebview.title
        } else if keyPath == "canGoBack" {
            navigationItem.leftBarButtonItems = wkWebview.canGoBack ? [backItem, closeItem] : [backItem]
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let type = WebViewScriptMessageHandlerName.init(rawValue: message.name) {
            messageToJs(type)
        }
    }
}

//MARK: - WKUIDelegate && WKNavigationDelegate
extension BaseWebViewController: WKUIDelegate, WKNavigationDelegate {

}
 
