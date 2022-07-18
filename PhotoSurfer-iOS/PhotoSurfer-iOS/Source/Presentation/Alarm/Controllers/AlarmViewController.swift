//
//  AlarmViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

final class AlarmViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Function
    private func setTableView() {
        registerXib()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = tableHeaderView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    private func registerXib() {
        tableView.register(UINib(nibName: Const.Identifier.AlarmListTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Const.Identifier.AlarmListTableViewCell)
    }
}
