//
//  HomeViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

final class HomeViewController: UIViewController {
    
    enum Section {
        case frequencyTag
    }
    
    // MARK: - Property
    var tags: [Tag] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollectionView()
        getFrequencyTag()
    }
    
    // MARK: - Function
    private func setUI() {
        setNavigationBarUI()
        setLabelUI()
        setSearchButtonUI()
    }
    
    private func setNavigationBarUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLabelUI() {
        if let title = titleLabel.text {
            let attributedStr = NSMutableAttributedString(string: title)
            attributedStr.addAttribute(.font, value: UIFont.iosTitle1M, range: (title as NSString).range(of: "어떤 사진을 향해"))
            attributedStr.addAttribute(.font, value: UIFont.iosTitle1B, range: (title as NSString).range(of: "서핑할까요?"))
            titleLabel.attributedText = attributedStr
        }
    }
    
    private func setSearchButtonUI() {
        searchButton.layer.borderColor = UIColor.pointBlue.cgColor
        searchButton.layer.borderWidth = 2
        searchButton.layer.cornerRadius = 22
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        registerXib()
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        setDataSource()
        applyTagSnapshot()
    }
    
    private func registerXib() {
        collectionView.register(UINib(nibName: Const.Identifier.TagCollectionViewCell, bundle: nil),
                                forCellWithReuseIdentifier: Const.Identifier.TagCollectionViewCell)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Tag>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Identifier.TagCollectionViewCell, for: indexPath) as? TagCollectionViewCell else { fatalError() }
            cell.setData(title: itemIdentifier.name, type: .defaultSkyblueTag)
            return cell
        })
    }
    
    private func applyTagSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.frequencyTag])
        snapshot.appendItems(tags, toSection: .frequencyTag)
        dataSource.apply(snapshot)
    }
    
    func goToHomeSearchViewController(inputTags: [Tag] = []) {
        guard let homeSearchViewController = UIStoryboard(name: Const.Storyboard.HomeSearch, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.HomeSearchViewController) as? HomeSearchViewController else { return }
        homeSearchViewController.hidesBottomBarWhenPushed = true
        homeSearchViewController.inputTags = inputTags
        self.navigationController?.pushViewController(homeSearchViewController, animated: true)
    }
    
    private func getFrequencyTag() {
        TagService.shared.getTagSearch { result in
            switch result {
            case .success(let data):
                guard let data = data as? TagResponse else { return }
                self.tags = data.tags
                self.applyTagSnapshot()
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
    
    // MARK: - IBAction
    @IBAction func tagInputButtonDidTap(_ sender: Any) {
        goToHomeSearchViewController()
    }
}
