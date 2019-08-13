//
//  HiveListViewController.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/9.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

/// The list page

class HiveListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var pathView: FilePathView!
    var mainTableView: UITableView!
    var driveType: DriveType!
    var fullPath: String!
    var path: String?
    var hiveClient: HiveClientHandle!
    var dataSource: Array<HiveItemInfo> = []
    var dHandle: HiveDirectoryHandle?
    var fHandle: HiveFileHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorHex("#f7f3f3")
        creatUI()
        requestChaildren(driveType, path: fullPath)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        request(driveType, path: path)
    }

    func creatUI() {

        pathView = FilePathView()
        self.view.backgroundColor = ColorHex("#f7f3f3")
        pathView.button.addTarget(self, action: #selector(creatDirectory), for: UIControl.Event.touchUpInside)
        self.view.addSubview(pathView)

        mainTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 55
        mainTableView.separatorStyle = .none
        mainTableView.register(HiveListCell.self, forCellReuseIdentifier: "HiveListCell")
        self.view.addSubview(mainTableView)

        pathView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(44)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(SAFE_BAR_Height)
        }

        mainTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(pathView.snp_bottom)

            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.bottom.equalToSuperview().offset(-49)
            }
        }
    }

    func requestChaildren(_ type: DriveType, path: String) {

        if path == "/" {
            requestRoot(type)
            return
        }
        switch type {
        case .nativeStorage: break
        case .oneDrive:
            hiveClient = HiveClientHandle.sharedInstance(type: .oneDrive)
        case .hiveIPFS:
            hiveClient = HiveClientHandle.sharedInstance(type: .hiveIPFS)
        case .dropBox: break
        case .ownCloud: break
        }

        hiveClient.defaultDriveHandle().then{ drive -> HivePromise<HiveDirectoryHandle> in
            return drive.directoryHandle(atPath: path)
            }.then{ directory -> HivePromise<HiveChildren> in
                self.dHandle = directory
                return directory.getChildren()
            }
            .done{ item in
                self.dataSource = item.children
                self.refreshUI()
                self.mainTableView.reloadData()
            }
            .catch { error in
                print(error)
        }
    }

    func requestRoot(_ type: DriveType) {
        switch type {
        case .nativeStorage: break
        case .oneDrive:
            hiveClient = HiveClientHandle.sharedInstance(type: .oneDrive)
        case .hiveIPFS:
            hiveClient = HiveClientHandle.sharedInstance(type: .hiveIPFS)
        case .dropBox: break
        case .ownCloud: break
        }

        hiveClient.defaultDriveHandle().then{ drive -> HivePromise<HiveDirectoryHandle> in
            return drive.rootDirectoryHandle()
            }.then{ rootDirectory -> HivePromise<HiveChildren> in
                self.dHandle = rootDirectory
                return rootDirectory.getChildren()
            }
            .done{ item in
                self.dataSource = item.children
                self.refreshUI()
                self.mainTableView.reloadData()
            }
            .catch { error in
                print(error)
        }
    }
    // MARK: refresh
    func refreshUI() {
        self.navigationItem.title = path
        self.pathView.containLable.text = fullPath
    }

    func computingFullPath(_ handle: HiveDirectoryHandle, _ selfName: String) -> String {

        let parentPath: String = handle.parentPathName()
        let pathName: String = handle.pathName
        var fullPath = "\(parentPath)/\(pathName)/\(selfName)"
        if parentPath == "/" {
            fullPath = "\(pathName)/\(selfName)"
        }
        if pathName == "/" {
            fullPath = "/\(selfName)"
        }
        return fullPath
    }

    //    MARK: tableviewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: HiveListCell = tableView.dequeueReusableCell(withIdentifier: "HiveListCell") as! HiveListCell
        cell.longPress.addTarget(self, action: #selector(longPressGestureAction(_:)))
        cell.model = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSource[indexPath.row].getValue(HiveItemInfo.type) == "folder" || dataSource[indexPath.row].getValue(HiveItemInfo.type) == "0" else {
            // TODO view for file
            return
        }

        let selfName: String = dataSource[indexPath.row].getValue(HiveItemInfo.name)
        let fullPath = computingFullPath(self.dHandle!, selfName)
        let newListVC = HiveListViewController()
        newListVC.path = selfName
        newListVC.fullPath = fullPath
        newListVC.driveType = driveType

        self.navigationController?.pushViewController(newListVC, animated: true)
    }

    // MARK: file / directory operation
    func operateDirectory(_ model: HiveModel) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let deleteAction: UIAlertAction = UIAlertAction(title: "删除", style: UIAlertAction.Style.default) { (action) in
        }
        let renameAction: UIAlertAction = UIAlertAction(title: "重命名", style: UIAlertAction.Style.default) { (action) in
        }
        let shareAction: UIAlertAction = UIAlertAction(title: "分享", style: UIAlertAction.Style.default) { (action) in
        }
        let uploadAction: UIAlertAction = UIAlertAction(title: "上传", style: UIAlertAction.Style.default) { (action) in
        }
        let cancleAction: UIAlertAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (action) in
        }
        sheet.addAction(deleteAction)
        sheet.addAction(renameAction)
        sheet.addAction(shareAction)
        sheet.addAction(uploadAction)
        sheet.addAction(cancleAction)
        sheet.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(sheet, animated: true, completion: nil)
    }

    func operateFile(_ model: HiveModel) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let deleteAction: UIAlertAction = UIAlertAction(title: "删除", style: UIAlertAction.Style.default) { (action) in
        }
        let renameAction: UIAlertAction = UIAlertAction(title: "重命名", style: UIAlertAction.Style.default) { (action) in
        }
        let cancleAction: UIAlertAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (action) in
        }
        sheet.addAction(deleteAction)
        sheet.addAction(renameAction)
        sheet.addAction(cancleAction)
        sheet.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(sheet, animated: true, completion: nil)
    }

// MARK --- action
    @objc func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {
        operateDirectory(HiveModel())
    }

    @objc func creatDirectory() {

        dHandle?.createDirectory(withName: "测试添加Directory-1").done{ directory in
            self.requestChaildren(self.driveType, path: self.fullPath)
            }.catch{ error in
                print(error)
        }
    }


}
