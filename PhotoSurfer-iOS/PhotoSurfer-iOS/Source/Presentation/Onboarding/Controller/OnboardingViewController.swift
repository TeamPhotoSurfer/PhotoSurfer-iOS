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
    //let onboardingContent: [UIImage] = [Const.Image.onboardingShare]
    let onboardingContent: [UIImage] = [Const.Image.onboardingShare, Const.Image.onboardingSearch, Const.Image.onboardingPushalarm]

    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    // MARK: - Function
    private func setUI() {
        setPageView()
//        scrollView.delegate = self
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
    
    func OnBoardingPageView(frame: CGRect, index: Int) -> UIView {
        let container = UIImageView(image: onboardingContent[index])
        container.contentMode = .scaleAspectFill
        container.frame = frame
        return container
    }
    
    // MARK: - IBAction
    @IBAction func nextButtonDidTap(_ sender: Any) {
        
    }
}

//extension OnboardingViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
//
//        if viewModel.currentPage != pageNumber {
//            self.pageControl.currentPage = pageNumber
//            changePageStyleWithAnimation(prevPage: viewModel.currentPage, nextPage: pageNumber)
//
//            viewModel.currentPage = pageNumber
//        }
//    }
//
//    private func changePageStyleWithAnimation(prevPage: Int, nextPage: Int) {
//        UIView.transition(with: buttonContainerView, duration: 0.3, options: [.transitionCrossDissolve], animations: {
//            if nextPage == viewModel.lastPageIndex {
//                self.skipButton.isHidden = true
//                self.startButton.isHidden = false
//                self.scrollView.backgroundColor = .white
//            } else {
//                self.skipButton.isHidden = false
//                self.startButton.isHidden = true
//                self.scrollView.backgroundColor = .gray
//            }
//        })
//    }
//}
