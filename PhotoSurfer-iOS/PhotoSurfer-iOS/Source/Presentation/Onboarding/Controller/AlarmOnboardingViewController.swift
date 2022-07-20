//
//  AlarmOnboardingViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 정연 on 2022/07/20.
//

import UIKit

class AlarmOnboardingViewController: UIViewController {
    
    // MARK: - Property
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let onboardingContent: [UIImage] = [Const.Image.onboardingAlarmShare, Const.Image.onboardingAlarmTag, Const.Image.onboardingAlarmAlarm]

    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
    
    // MARK: - Objc Function
    @objc func panAction (_ sender : UIPanGestureRecognizer){
        let velocity = sender.velocity(in: scrollView)
        if pageControl.currentPage == 2 {
            if abs(velocity.x) > abs(velocity.y) {
                if velocity.x < 0 {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}

extension AlarmOnboardingViewController: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
                setPageControlSelectedPage(currentPage: Int(round(value)))
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
