//
//  ZJLoginView.swift
//  DouYuLive
//
//  Created by 邓志坚 on 2018/9/14.
//  Copyright © 2018年 邓志坚. All rights reserved.
//

import UIKit
import RxSwift
enum ZJLoginType {
    case ZJLogin
    case ZJRegister
}
private let mobileNumLength = 11
private let minPwdLength = 6
class ZJLoginView: ZJBaseView {
    
    var type : ZJLoginType? = .ZJLogin
    
    // 地区
    private lazy var areaView : UIView = UIView()
    private lazy var areaLab : UILabel = UILabel()
    private lazy var areaImgV : UIImageView = UIImageView()
    private lazy var areaNameLab : UILabel = UILabel()
    
    // 手机
    private lazy var mobileView : UIView = UIView()
    private lazy var mobileBtn : UIButton = UIButton()
    private lazy var mobileTF : UITextField = UITextField()
    private lazy var mobileValid : UILabel = UILabel()
    // 密码
    private lazy var pwdView : UIView = UIView()
    private lazy var pwdImgV : UIImageView = UIImageView()
    private lazy var pwdTF : UITextField = UITextField()
    private lazy var pwdValid : UILabel = UILabel()
    
    // 验证码
    private lazy var codeView : UIView = UIView()
    private lazy var codeImgV : UIImageView = UIImageView()
    private lazy var codeTF : UITextField = UITextField()
    private lazy var codeBtn : UIButton = UIButton()
    
    // 登录或注册按钮
    lazy var actionBtn : UIButton = UIButton()
    // 忘记密码按钮
    private lazy var forgetBtn : UIButton = UIButton()
    // 验证码登录按钮
    private lazy var codeLoginBtn : UIButton = UIButton()
    // 快速注册按钮
    private lazy var quickRegisterBtn : UIButton = UIButton()
    // 马上登录按钮
    private lazy var nowLoginBtn : UIButton = UIButton()
    
    private lazy var bag : DisposeBag = DisposeBag()
    
    // 自定义初始化方法
    init(frame : CGRect, viewType : ZJLoginType) {
        self.type = viewType
        super.init(frame: frame)
        setUpAllView()
        textFieldvalid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension ZJLoginView {
    
    // textfield 的验证
    func textFieldvalid() {
        // 获取输入手机号码的状态
        let mobileLengValid = mobileTF.rx.text.orEmpty
            .map { $0.count == mobileNumLength }
            .share(replay: 1) //如果没有这个映射，每个绑定只执行一次，那么rx在默认情况下是无状态的
        // 获取输入密码的状态
        let pwdLengValid = pwdTF.rx.text.orEmpty
            .map { $0.count >= minPwdLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(mobileLengValid, pwdLengValid) { $0 && $1 }
            .share(replay: 1)
        
        
        // 动态绑定手机号码提示,是否需要隐藏
        // disposed(by: disposeBag)就是将绑定的生命周期交给 disposeBag 来管理。
        // 当 disposeBag 被释放的时候，那么里面尚未清除的绑定也就被清除了。这就相当于是在用 ARC 来管理绑定的生命周期
        mobileLengValid
            .bind(to: mobileValid.rx.isHidden)
            .disposed(by: bag)
        
        // 动态绑定密码的提示,是否需要隐藏
        pwdLengValid
            .bind(to: pwdValid.rx.isHidden)
            .disposed(by: bag)
        
        // 动态绑定状态
        everythingValid
            .bind(to: actionBtn.rx.isEnabled)
            .disposed(by: bag)
        
        // 登录或注册按钮的点击事件
//        actionBtn.rx.tap
//            .subscribe(onNext: {
//                
//            })
//            .disposed(by: bag)
    }
    
}

// 配置 UI 视图
extension ZJLoginView {
    
    private func setUpAllView() {
        backgroundColor = kBGGrayColor
        
        areaView = UIView.zj_createView(bgClor: kWhite, supView: self, closure: { (make) in
            make.left.equalTo(Adapt(20))
            make.right.equalTo(Adapt(-20))
            make.top.equalTo(Adapt(20))
            make.height.equalTo(Adapt(40))
        })
        
        areaView.layer.cornerRadius = 5
        
        areaLab = UILabel.zj_createLabel(text: "国家与地区", textColor:  kGrayTextColor, font: FontSize(14), supView: areaView, closure: { (make) in
            make.centerY.equalTo(areaView.snp.centerY)
            make.left.equalTo(areaView.snp.left).offset(Adapt(10))
            make.width.equalTo(Adapt(110))
        })
        
        areaImgV = UIImageView.zj_createImageView(imageName: "right_arrow_gray", supView: areaView, closure: { (make) in
            make.centerY.equalTo(areaView.snp.centerY)
            make.right.equalTo(areaView.snp.right).offset(-Adapt(8))
            make.width.equalTo(Adapt(9))
            make.height.equalTo(Adapt(15))
        })
        areaImgV.contentMode = .scaleAspectFit
        
        areaNameLab = UILabel.zj_createLabel(text: "中国", textColor: kMainTextColor, font: FontSize(14), supView: areaView, closure: { (make) in
            make.centerY.equalTo(areaView.snp.centerY)
            make.right.equalTo(areaImgV.snp.left).offset(Adapt(-10))
        })
        areaNameLab.textAlignment = .right
        
        mobileView = UIView.zj_createView(bgClor: kWhite, supView: self, closure: { (make) in
            make.top.equalTo(areaView.snp.bottom).offset(Adapt(10))
            make.left.equalTo(Adapt(20))
            make.right.equalTo(Adapt(-20))
            make.height.equalTo(Adapt(40))
        })
        mobileView.layer.cornerRadius = 5
        
        mobileBtn = UIButton.zj_createButton(title: "+86", titleStatu: .normal, imageName: nil, imageStatu: nil, supView: mobileView, closure: { (make) in
            make.left.equalTo(Adapt(5))
            make.centerY.equalTo(mobileView.snp.centerY)
            make.width.equalTo(Adapt(60))
            make.height.equalTo(Adapt(30))
        })

        mobileBtn.titleLabel?.font = FontSize(14)
        mobileBtn.setTitleColor(kMainOrangeColor, for: .normal)
        
        mobileTF = UITextField.zj_createTextField(text: "", textColor: kMainTextColor, placeholder: "请输入手机号", font:  FontSize(14), textAlignment: .left, borderStyle: .none, supView: mobileView, closure: { (make) in
            make.centerY.equalTo(mobileView.snp.centerY)
            make.left.equalTo(mobileBtn.snp.right).offset(Adapt(15))
            make.right.equalTo(Adapt(-15))
            make.height.equalTo(35)
        })
        mobileValid = UILabel.zj_createLabel(text: "请输入正确的手机号码", textColor:  kRed, font: FontSize(10), supView: self, closure: { (make) in
            make.top.equalTo(mobileView.snp.bottom)
            make.left.equalTo(mobileView.snp.left)
            make.right.equalTo(mobileView.snp.right)
            make.height.equalTo(Adapt(18))
        })
        mobileValid.isHidden = true
        
        pwdView = UIView.zj_createView(bgClor: kWhite, supView: self, closure: { (make) in
            make.top.equalTo(mobileView.snp.bottom).offset(Adapt(20))
            make.left.equalTo(Adapt(20))
            make.right.equalTo(Adapt(-20))
            make.height.equalTo(Adapt(40))
        })
        pwdView.layer.cornerRadius = 5
        
        pwdImgV = UIImageView.zj_createImageView(imageName: "tf_login_password", supView: pwdView, closure: { (make) in
            make.left.equalTo(Adapt(15))
            make.width.height.equalTo(Adapt(18))
            make.centerY.equalTo(pwdView.snp.centerY)
        })
        
        pwdTF = UITextField.zj_createTextField(text: "", textColor: kMainTextColor, placeholder: "请输入密码", font:  FontSize(14), textAlignment: .left, borderStyle: .none, supView: pwdView, closure: { (make) in
            make.centerY.equalTo(pwdView.snp.centerY)
            make.left.equalTo(pwdImgV.snp.right).offset(Adapt(15))
            make.right.equalTo(Adapt(-15))
            make.height.equalTo(Adapt(35))
        })
        
        pwdValid = UILabel.zj_createLabel(text: "密码必须大于6位数", textColor:  kRed, font: FontSize(10), supView: self, closure: { (make) in
            make.top.equalTo( pwdView.snp.bottom)
            make.left.equalTo(pwdView.snp.left)
            make.right.equalTo(pwdView.snp.right)
            make.height.equalTo(Adapt(18))
        })
        
        pwdValid.isHidden = true
        
        if self.type == ZJLoginType.ZJLogin {
            // 添加登录按钮
            setUpActionBtn(type: self.type!)
        }else{
            // 添加验证码视图
            setUpCodeView()
            // 添加注册按钮
            setUpActionBtn(type: self.type!)
        }
        
        
    }
    
    
    // 添加验证码视图
    func setUpCodeView() {
        codeView = UIView.zj_createView(bgClor: kWhite, supView: self, closure: { (make) in
            make.top.equalTo(pwdView.snp.bottom).offset(Adapt(20))
            make.left.equalTo(Adapt(20))
            make.right.equalTo(Adapt(-20))
            make.height.equalTo(Adapt(40))
        })
        codeView.layer.cornerRadius = 5
        
        codeImgV = UIImageView.zj_createImageView(imageName: "tf_login_verificationCode", supView: codeView, closure: { (make) in
            make.left.equalTo(Adapt(15))
            make.width.height.equalTo(Adapt(18))
            make.centerY.equalTo(codeView.snp.centerY)
        })
        
        codeBtn = UIButton.zj_createButton(title: "短信验证", titleStatu: . normal, imageName: nil, imageStatu: nil, supView: codeView, closure: { (make) in
            make.centerY.equalTo(codeView.snp.centerY)
            make.right.equalTo(-Adapt(10))
            make.width.equalTo(Adapt(70))
            make.height.equalTo(Adapt(30))
        })
        codeBtn.layer.cornerRadius = 4
        codeBtn.titleLabel?.font = FontSize(12)
        codeBtn.setTitleColor(kWhite, for: .normal)
        codeBtn.backgroundColor = kMainOrangeColor
        
        codeTF = UITextField.zj_createTextField(text: "", textColor: kMainTextColor, placeholder: "请输入验证码", font:  FontSize(14), textAlignment: .left, borderStyle: .none, supView: codeView, closure: { (make) in
            make.centerY.equalTo(codeView.snp.centerY)
            make.left.equalTo(codeImgV.snp.right).offset(Adapt(15))
            make.right.equalTo(codeBtn.snp.left).offset(-Adapt(10))
            make.height.equalTo(Adapt(35))
        })
        
    }
    
    
    func setUpActionBtn(type: ZJLoginType){
        if type == .ZJLogin {
            actionBtn = UIButton.zj_createButton(title: "登录", titleStatu: . normal, imageName: nil, imageStatu: nil, supView: self, closure: { (make) in
                make.top.equalTo(pwdView.snp.bottom).offset(Adapt(30))
                make.left.equalTo(Adapt(20))
                make.right.equalTo(Adapt(-20))
                make.height.equalTo(Adapt(40))
            })
            
            forgetBtn = UIButton.zj_createButton(title: "忘记密码", titleStatu: . normal, titleColor: kGrayTextColor, imageName: nil, imageStatu: nil, font: FontSize(13), supView: self, closure: { (make) in
                make.top.equalTo(actionBtn.snp.bottom).offset(Adapt(5))
                make.left.equalTo(actionBtn.snp.left)
                make.width.equalTo(Adapt(70))
                make.height.equalTo(Adapt(30))
            })
            
            codeLoginBtn = UIButton.zj_createButton(title: "验证码快捷登录", titleStatu: . normal, titleColor:  kMainOrangeColor, imageName: nil, imageStatu: nil, font: FontSize(13), supView: self, closure: { (make) in
                make.top.equalTo(actionBtn.snp.bottom).offset(Adapt(5))
                make.centerX.equalTo(actionBtn.snp.centerX)
                make.width.equalTo(Adapt(100))
                make.height.equalTo(Adapt(30))
            })
            
            quickRegisterBtn = UIButton.zj_createButton(title: "快速注册", titleStatu: . normal, titleColor:  kMainOrangeColor, imageName: nil, imageStatu: nil, font: FontSize(13), supView: self, closure: { (make) in
                make.top.equalTo(actionBtn.snp.bottom).offset(Adapt(5))
                make.right.equalTo(actionBtn.snp.right)
                make.width.equalTo(Adapt(70))
                make.height.equalTo(Adapt(30))
            })
        }else{
            actionBtn = UIButton.zj_createButton(title: "注册", titleStatu: . normal, imageName: nil, imageStatu: nil, supView: self, closure: { (make) in
                make.top.equalTo(codeView.snp.bottom).offset(Adapt(30))
                make.left.equalTo(Adapt(20))
                make.right.equalTo(Adapt(-20))
                make.height.equalTo(Adapt(40))
            })
            
            nowLoginBtn = UIButton.zj_createButton(title: "马上登录", titleStatu: . normal, titleColor:  kMainOrangeColor, imageName: nil, imageStatu: nil, font: FontSize(13), supView: self, closure: { (make) in
                make.top.equalTo(actionBtn.snp.bottom).offset(Adapt(5))
                make.right.equalTo(actionBtn.snp.right)
                make.width.equalTo(Adapt(70))
                make.height.equalTo(Adapt(30))
            })
        }
        
        actionBtn.layer.cornerRadius = 5
        actionBtn.backgroundColor = kMainOrangeColor
        actionBtn.setTitleColor(kWhite, for: .normal)
        actionBtn.titleLabel?.font = FontSize(15)
    }
}
