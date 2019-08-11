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
    var path: String!
    var hiveClient: HiveClientHandle!
    var dataSource: Array<HiveItemInfo> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorHex("#f7f3f3")
        creatUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request(driveType, path: path)
    }

    func creatUI() {

        pathView = FilePathView()
        self.view.backgroundColor = ColorHex("#f7f3f3")
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

    func request(_ type: DriveType, path: String) {

        if path == "root" {
            requestRoot(type)
            return
        }
        switch type {
        case .nativeStorage: break
        case .oneDrive: break
        case .hiveIPFS: break
        case .dropBox: break
        case .ownCloud: break
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
                return rootDirectory.getChildren()
            }
            .done{ item in
                self.dataSource = item.children
                self.mainTableView.reloadData()
            }
            .catch { error in
                print(error)
        }
    }

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
        request(driveType, path: path) // todo
    }


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
}
