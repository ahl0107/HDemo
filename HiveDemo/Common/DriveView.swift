//
//  DriveView.swift
//  HiveDemo
//
//  Created by 李爱红 on 2019/8/8.
//  Copyright © 2019 elastos. All rights reserved.
//

import UIKit
import SnapKit

class DriveView: UIView {

    var containerView: UIView!
    var nameLable: UILabel!
    var button: UIButton!


    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatUI() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        containerView = UIView()
        if #available(iOS 11.0, *) {
            containerView.layer.cornerRadius = 10
            containerView.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue | CACornerMask.layerMaxXMinYCorner.rawValue)
        }else {
            containerView.filletedCorner(CGSize(width: 5, height: 5), UIRectCorner(rawValue: (UIRectCorner.topLeft.rawValue)|(UIRectCorner.topRight.rawValue)))
        }
        self.addSubview(self.containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.width.height.equalToSuperview()
        }

        nameLable = UILabel()
        nameLable.textAlignment = NSTextAlignment.center
        addSubview(self.nameLable)
        nameLable.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(44)
            make.center.equalToSuperview()
        }

        button = UIButton()
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
    }



}

// MARK: - 给view扩展设置部分角是原角的方法
extension UIView {

    /// 设置多个圆角
    ///
    /// - Parameters:
    ///   - cornerRadii: 圆角幅度
    ///   - roundingCorners: UIRectCorner(rawValue: (UIRectCorner.topRight.rawValue) | (UIRectCorner.bottomRight.rawValue))
    public func filletedCorner(_ cornerRadii:CGSize,_ roundingCorners:UIRectCorner)  {
        let fieldPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii:cornerRadii )
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = bounds
        fieldLayer.path = fieldPath.cgPath
        self.layer.mask = fieldLayer
    }
}
