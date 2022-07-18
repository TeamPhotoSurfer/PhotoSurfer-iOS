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
            guard let loginViewController = UIStoryboard(name: Const.Storyboard.Login, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.LoginViewController) as? LoginViewController else { fatalError() }
            guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            delegate.window?.rootViewController = loginViewController
        }
    }
}
