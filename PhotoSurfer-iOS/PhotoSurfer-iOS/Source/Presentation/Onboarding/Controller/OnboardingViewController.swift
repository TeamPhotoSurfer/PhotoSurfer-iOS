//
//  OnboardingViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/19.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Property
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let onboardingContent: [UIImage] = [Const.Image.onboardingShare, Const.Image.onboardingSearch, Const.Image.onboardingPushalarm]
    

    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        setPageView()
        setPageControl()
        scrollView.delegate = self
        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecongnizer.delegate = self
        self.view.addGestureRecognizer(panGestureRecongnizer)
    }
    private func setPageView() {
        scrollView.frame.size.width = screenWidth
        scrollView.frame.size.height = screenHeight
        let scrollWidth = scrollView.frame.size.width
        let scrollHeight = scrollView.frame.size.height
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        frame.size = scrollView.frame.size
        frame.size.height = scrollHeight

        for index in 0..<onboardingContent.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            let onboardingPage = OnBoardingPageView(frame: frame, index: index)
            scrollView.addSubview(onboardingPage)
        }
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(onboardingContent.count), height: scrollHeight)
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = onboardingContent.count
        
    }
    
    func OnBoardingPageView(frame: CGRect, index: Int) -> UIView {
        let container = UIImageView(image: onboardingContent[index])
        container.contentMode = .scaleAspectFill
        container.frame = frame
        return container
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    
    func setRootViewController(name: String, identifier: String) {
        let viewController = UIStoryboard(name: name, bundle: nil)
            .instantiateViewController(withIdentifier: identifier)
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        delegate.window?.rootViewController = viewController
    }
    
    @objc func panAction (_ sender : UIPanGestureRecognizer){
        let velocity = sender.velocity(in: scrollView)
        if pageControl.currentPage == 2 {
            if abs(velocity.x) > abs(velocity.y) {
                if velocity.x < 0 {
                    setRootViewController(name: Const.Storyboard.Login, identifier: Const.ViewController.LoginViewController)
                }
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func nextButtonDidTap(_ sender: Any) {
        setRootViewController(name: Const.Storyboard.Login, identifier: Const.ViewController.LoginViewController)
    }
}

extension OnboardingViewController: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
                setPageControlSelectedPage(currentPage: Int(round(value)))
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
