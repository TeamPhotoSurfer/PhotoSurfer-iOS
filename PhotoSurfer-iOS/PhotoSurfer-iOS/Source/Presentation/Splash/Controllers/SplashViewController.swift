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
        finishLottie(name: name, animationView: animationView)
    }
    
    func finishLottie(name: String, animationView: AnimationView) {
        animationView.play { (finish) in
            animationView.removeFromSuperview()
            guard let onboardingViewController = UIStoryboard(name: Const.Storyboard.Onboarding, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.OnboardingViewController) as? OnboardingViewController else { fatalError() }
            guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            delegate.window?.rootViewController = onboardingViewController
        }
    }
}

extension SceneDelegate {
    func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            return true
        } else {
            return false
        }
    }
    
    private func setRootViewController(_ scene: UIScene){
        if isFirstTime() {
            setRootViewController(scene, name: Const.Storyboard.Onboarding,
                                  identifier: Const.ViewController.OnboardingViewController)
        }
        // TODO: 여기 로그인 여부로 또 분기처리 해야하나? 로그인 했으면 Main으로 넘기기 이런식으로..
        else {
            setRootViewController(scene, name: Const.Storyboard.Login,
                                  identifier: Const.ViewController.LoginViewController)
        }
    }
    
    private func setRootViewController(_ scene: UIScene, name: String, identifier: String) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard(name: name, bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
            window.rootViewController = viewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
