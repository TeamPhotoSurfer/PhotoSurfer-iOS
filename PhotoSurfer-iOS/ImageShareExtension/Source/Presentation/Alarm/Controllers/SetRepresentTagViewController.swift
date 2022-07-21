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
        
        setCollectionView()
        registerXib()
        setUI()
        setRepresentTag()
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
    
    private func setRepresentTag() {
        selectedTags = tags
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
