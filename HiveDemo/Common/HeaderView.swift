//
//  HeaderView.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit
import SnapKit

class HeaderView: UIView {

    var icon: UIImageView!
    var line: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatUI() {
        icon = UIImageView(image: UIImage(named: "icon"))
        self.addSubview(icon)
        icon.frame = CGRect(x: 30, y: 60, width: 60, height: 60)
    }



}
