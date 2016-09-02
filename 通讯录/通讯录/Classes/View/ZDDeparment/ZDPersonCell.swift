//
//  ZDPersonCell.swift
//  通讯录
//
//  Created by zhudong on 16/8/25.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit
import SnapKit

let Margin: Float = 8
class ZDPersonCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        contentView.addSubview(departmentLabel)
        contentView.addSubview(positionLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(telephoneLabel)
        contentView.addSubview(emailLabel)
        departmentLabel.snp_makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(Margin)
        }
        positionLabel.snp_makeConstraints { (make) in
            make.left.equalTo(departmentLabel.snp_right).offset(Margin)
            make.bottom.equalTo(departmentLabel)
        }
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(departmentLabel)
            make.top.equalTo(departmentLabel.snp_bottom)
            make.bottom.equalTo(contentView).offset(-Margin)
        }
        telephoneLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp_right).offset(Margin)
        }
        emailLabel.snp_makeConstraints { (make) in
            make.left.equalTo(telephoneLabel.snp_right).offset(Margin)
            make.bottom.equalTo(telephoneLabel)
        }
        let sepV: UIView = {
            let v = UIView()
            v.backgroundColor = UIColor.grayColor()
            return v
        }()
        contentView.addSubview(sepV)
        sepV.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        emailLabel.highlightTapAction = { ( containerView :UIView , text: NSAttributedString, range:NSRange, rect:CGRect) -> () in
//            let mailVC = ZDMailViewController()
//            let str = (text.string as NSString).substringWithRange(range)
//            let nav = self.findNavigationController()!
//            nav.pushViewController(mailVC, animated: true)
        }
    }
    var person: ZDPerson?{
        didSet{
            departmentLabel.text = person?.department
            positionLabel.text = person?.position
            //labelname.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
//            let attri = [NSForegroundColorAttributeName:UIColor.blackColor(),NSObliquenessAttributeName:0.5]
            let attri = [NSForegroundColorAttributeName:UIColor.blueColor()]
            let attrM = NSMutableAttributedString(string: (person?.name)!, attributes:attri)
            let attrMTel = NSMutableAttributedString(string: (person?.telephone)!, attributes: [NSFontAttributeName:UIFont(name: "Helvetica-Bold", size: 20)!])
            nameLabel.attributedText = attrM
            
            let nameSize = (person?.name)!.boundingRectWithSize(CGSizeMake(CGFloat.max, 10), options: .UsesLineFragmentOrigin, attributes: attri, context: nil).size
            let newWidth = nameSize.width + CGFloat(3 * Margin)
            nameLabel.snp_updateConstraints { (make) in
                make.width.equalTo(newWidth)
            }
            telephoneLabel.attributedText = attrMTel
            //[NSNumber numberWithInteger:NSUnderlineStyleSingle]
            
            let attri_email = [NSUnderlineStyleAttributeName:NSNumber(integer:NSUnderlineStyle.StyleSingle.rawValue),NSFontAttributeName:UIFont.systemFontOfSize(17)]
            let attrM_email = NSMutableAttributedString(string: (person?.email)!, attributes: attri_email)
            let highlight = YYTextHighlight()
            highlight.setColor(UIColor.redColor())
            let border = YYTextBorder(fillColor: UIColor.grayColor(), cornerRadius: 3)
            highlight.setBackgroundBorder(border)
            attrM_email.yy_setTextHighlight(highlight, range: NSMakeRange(0, (person?.email?.characters.count)!))
            emailLabel.attributedText = attrM_email
        }
    }
    
    lazy var departmentLabel: UILabel = {
        let label = ZDPersonCell.getLabel()
        return label
    }()
    lazy var positionLabel: UILabel = {
        let label = ZDPersonCell.getLabel()
        return label
    }()
    lazy var nameLabel: UILabel = {
        let label: UILabel = ZDPersonCell.getLabel()
        return label
    }()
    lazy var telephoneLabel: UILabel = {
        let label = ZDPersonCell.getLabel()
        return label
    }()
    lazy var emailLabel: YYLabel = {
        let label: YYLabel = YYLabel()
        return label
    }()

    private class func getLabel() -> UILabel {
        let l = UILabel()
        l.font = UIFont.systemFontOfSize(17)
        l.textColor = UIColor.blackColor()
        return l
    }
}
