//
//  SplashViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/18.
//

import UIKit
import Lottie

final class SplashViewController: UIViewController {
    // MARK: - Property
    var gradientLayer: CAGradientLayer!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Function
    func setUI() {
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.colors = [UIColor.splashGradientTop.cgColor, UIColor.splashGradientBottom.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        self.view.layer.addSublayer(self.gradientLayer)
        setLottie(name: "Bubble")
        setLottie(name: "Symbol")
    }
    
    func setLottie(name: String) {
        let animationView: AnimationView = .init(name: name)
        self.view.addSubview(animationView)
        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        if name == "Bubble" {
            finishLottie(name: name, animationView: animationView)
        } else {
            animationView.play()
        }
    }
    
    func finishLottie(name: String, animationView: AnimationView) {
        animationView.play { (finish) in
            animationView.removeFromSuperview()
            self.setRoot()
        }
    }
    
    func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            print("isFirst == true")
            return true
        } else {
            print("isFirst == false")
            return false
        }
    }
    
    private func setRoot() {
        if isFirstTime() {
            setRootViewController(name: Const.Storyboard.Onboarding,
                                  identifier: Const.ViewController.OnboardingViewController)
        }
        // TODO: 여기 로그인 여부로 또 분기처리 해야하나? 로그인 했으면 Main으로 넘기기 이런식으로..
        else {
            setRootViewController(name: Const.Storyboard.Login,
                                  identifier: Const.ViewController.LoginViewController)
        }
    }
    
    func setRootViewController(name: String, identifier: String) {
        let viewController = UIStoryboard(name: name, bundle: nil)
            .instantiateViewController(withIdentifier: identifier)
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        delegate.window?.rootViewController = viewController
    }
}
