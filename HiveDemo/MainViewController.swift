//
//  ViewController.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var leftVC: LeftViewController = LeftViewController()
    var draw: Drawer!
    var mainTable: UITableView!
    var ipfsDrive: DriveView!
    var oneDrive: DriveView!
    var driveStackView: UIStackView!

    var line: UIView!

    var myCard: DriveView!
    var addFriend: DriveView!
    var myFriend: DriveView!
    var funStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hive"
        self.view.backgroundColor = ColorHex("#f7f3f3")
        draw = Drawer(self.navigationController!, leftVC)
        createLeftItem()
        creatUI()
    }

    func createLeftItem() {
        let img = UIImage(named: "user")
        let item0 = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(leftList))
        self.navigationItem.leftBarButtonItem = item0
    }

    func creatUI() {
        ipfsDrive = DriveView()
        ipfsDrive.nameLable.text = "ipfsrive"

        oneDrive = DriveView()
        oneDrive.nameLable.text = "OneDrive"
        driveStackView = UIStackView(arrangedSubviews: [ipfsDrive, oneDrive])
        driveStackView.frame = CGRect(x: 20, y: SAFE_BAR_Height + 40, width: SCREEN_WIDTH - 40, height: 88)
        driveStackView.axis = NSLayoutConstraint.Axis.horizontal
        driveStackView.alignment = UIStackView.Alignment.fill
        driveStackView.distribution = UIStackView.Distribution.fillEqually
        driveStackView.spacing = 20
        self.view.addSubview(driveStackView)

        line = UIView()
        line.backgroundColor = ColorHex("#eae7e7")
        self.view.addSubview(line)

        line.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(2)
            make.top.equalTo(driveStackView.snp_bottom).offset(40)
        }

        myCard = DriveView()
        myCard.nameLable.text = "my card"

        addFriend = DriveView()
        addFriend.nameLable.text = "add Friend"

        myFriend = DriveView()
        myFriend.nameLable.text = "my Friend"

        funStackView = UIStackView(arrangedSubviews: [myCard, addFriend, myFriend])
        funStackView.axis = NSLayoutConstraint.Axis.horizontal
        funStackView.alignment = UIStackView.Alignment.fill
        funStackView.distribution = UIStackView.Distribution.fillEqually
        funStackView.spacing = 20
        self.view.addSubview(funStackView)

        funStackView.snp.makeConstraints { make in
            make.top.equalTo(line.snp_bottom).offset(40)
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(66)
        }

    }

   @objc func leftList() {
    draw.show()
    }

}

