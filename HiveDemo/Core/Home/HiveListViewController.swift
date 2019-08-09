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

    var mainTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorHex("#f7f3f3")
        creatUI()
    }

    func creatUI() {
        mainTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 55
        mainTableView.separatorStyle = .none
        mainTableView.register(HiveListCell.self, forCellReuseIdentifier: "HiveListCell")
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()

            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview().offset(-49)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: HiveListCell = tableView.dequeueReusableCell(withIdentifier: "HiveListCell") as! HiveListCell
        cell.longPress.addTarget(self, action: #selector(longPressGestureAction(_:)))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(tableView)
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
