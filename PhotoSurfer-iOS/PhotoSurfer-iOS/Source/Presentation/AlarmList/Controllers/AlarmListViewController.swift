//
//  AlarmListViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/18.
//

import UIKit

final class AlarmListViewController: UIViewController {
    
    enum ListMode {
        case last
        case coming
    }

    // MARK: - IBOutlet
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    // MARK: - Function
    func setMode(_ mode: ListMode) {
        switch mode {
        case .coming:
            navigationTitleLabel.text = "다가오는 알림"
        case .last:
            navigationTitleLabel.text = "지난 알림"
        }
    }
    
    private func setTableView() {
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerXib() {
        tableView.register(UINib(nibName: Const.Identifier.AlarmListTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Const.Identifier.AlarmListTableViewCell)
    }
}
