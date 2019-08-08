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
    var draw: Drawer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hive"
        self.view.backgroundColor = UIColor.white
        draw = Drawer(self.navigationController!, leftVC)
        createLeftItem()

    }

    func createLeftItem() {
        let img = UIImage(named: "user")
        let item0 = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(leftList))
        self.navigationItem.leftBarButtonItem = item0
    }

   @objc func leftList() {
    draw!.show()
    }

}

