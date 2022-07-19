//
//  SetRepresentTagViewController.swift
//  ImageShareExtension
//
//  Created by 김하늘 on 2022/07/17.
//

import UIKit

final class SetRepresentTagViewController: UIViewController {

    // MARK: - Property
    var tags: [Tag] = []
    var delegate: SetSelectedRepresentTag?
    var selectedTags: [Tag] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDummy()
        setCollectionView()
        registerXib()
        setUI()
    }
    
    // MARK: - Function
    private func registerXib() {
        tableView.register(UINib(nibName: RepresentTagTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: RepresentTagTableViewCell.identifier)
    }
    
    private func setCollectionView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8.0
        
    }
    
    private func setUI() {
        saveButton.setTitleColor(.grayGray60, for: .disabled)
        saveButton.setTitleColor(.pointMain, for: .normal)
    }
    
    // MARK: - IBAction
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIButton) {
        delegate?.sendSelectedRepresentTag(tags: selectedTags)
        self.navigationController?.popViewController(animated: true)
    }
}

// 이후 삭제할 부분이라 아래에 바로 넣어놓음
extension SetRepresentTagViewController {
    private func setDummy() {
        tags = [Tag(title: "휴학계획"), Tag(title: "인턴"), Tag(title: "블로그"), Tag(title: "취준"), Tag(title: "채용공고"), Tag(title: "스펙")]
    }
}
