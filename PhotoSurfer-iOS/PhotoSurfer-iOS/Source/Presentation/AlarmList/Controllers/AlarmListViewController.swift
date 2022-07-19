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
    
    // MARK: - Property
    var pushes: [Push] = []
    var mode: ListMode = .coming
    
    // MARK: - IBOutlet
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setMode(mode)
    }
    
    // MARK: - Function
    func setMode(_ mode: ListMode) {
        switch mode {
        case .coming:
            navigationTitleLabel.text = "다가오는 알림"
            getPushComing()
        case .last:
            navigationTitleLabel.text = "지난 알림"
            getPushLast()
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
    
    private func getPushLast() {
        PushService.shared.getPushListLast { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data as? PushResponse else { return }
                self?.pushes = data.push
                self?.tableView.reloadData()
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
    
    private func getPushComing() {
        PushService.shared.getPushListComing{ [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data as? PushResponse else { return }
                self?.pushes = data.push
                self?.tableView.reloadData()
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
}
