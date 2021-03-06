//
//  LoginViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/18.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKUser
import Lottie

class LoginViewController: UIViewController {
    
    // MARK: - Property
    var gradientLayer: CAGradientLayer!
    var accessToken: String = ""
    var refreshToken: String = ""
    
    // MARK: - IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var kakaoLoginImageView: UIImageView!
    @IBOutlet weak var appleLoginImageView: UIImageView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Function
    func setUI() {
        setGradientBackGround()
        setLottie()
        setUIImageTapAction()
    }
    
    func setGradientBackGround() {
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.colors = [UIColor.splashGradientTop.cgColor, UIColor.splashGradientBottom.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        backgroundView.layer.addSublayer(self.gradientLayer)
    }
    
    func setLottie() {
        let animationView: AnimationView = .init(name: "Bubble")
        backgroundView.addSubview(animationView)
        animationView.frame = backgroundView.bounds
        animationView.center = backgroundView.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func setUIImageTapAction() {
        let kakaoLoginTapGesture = UITapGestureRecognizer(target: self, action: #selector(kakaoLoginImageViewDidTap))
        kakaoLoginImageView.isUserInteractionEnabled = true
        kakaoLoginImageView.addGestureRecognizer(kakaoLoginTapGesture)
    }
    
    func changeRootViewController() {
        guard let mainTabBarController = UIStoryboard(name: Const.Storyboard.Main, bundle: nil)
            .instantiateViewController(withIdentifier: Const.ViewController.MainTabBarController) as? MainTabBarController else { fatalError() }
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        delegate.window?.rootViewController = mainTabBarController
    }
    
    func postAuthLogin(authRequest: AuthRequest) {
        let authRequest: AuthRequest = authRequest
        AuthService.shared.postAuthLogin(authRequest: authRequest) { result in
            switch result {
            case .success(let data):
                self.changeRootViewController()
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    // MARK: - Objc Function
    @objc func kakaoLoginImageViewDidTap(sender: UITapGestureRecognizer) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [self](oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오톡 로그인 loginWithKakaoTalk() success.")
                    _ = oauthToken
                    if let accessToken = oauthToken?.accessToken {
                        self.accessToken = accessToken
                        print("✨accessToken", accessToken)
                    }
                    if let refreshToken = oauthToken?.refreshToken {
                        self.refreshToken = refreshToken
                        print("✨refreshToken", refreshToken)
                    }
                    let authRequest = AuthRequest(socialToken: self.accessToken, socialType: "kakao")
                    postAuthLogin(authRequest: authRequest)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오 계정 로그인 loginWithKakaoAccount() success.")
                    _ = oauthToken
                    if let accessToken = oauthToken?.accessToken {
                        self.accessToken = accessToken
                        print("✨accessToken", accessToken)
                    }
                    if let refreshToken = oauthToken?.refreshToken {
                        self.refreshToken = refreshToken
                        print("✨refreshToken", refreshToken)
                    }
                    let authRequest = AuthRequest(socialToken: self.accessToken, socialType: "kakao")
                    self.postAuthLogin(authRequest: authRequest)
                }
            }
        }
    }
}
