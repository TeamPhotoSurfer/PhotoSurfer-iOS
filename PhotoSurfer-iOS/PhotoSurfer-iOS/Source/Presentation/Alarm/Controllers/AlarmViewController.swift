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
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var statusBarBackgroundView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    // MARK: - Function
    private func setTableView() {
        registerXib()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = tableHeaderView
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerXib() {
        tableView.register(UINib(nibName: Const.Identifier.AlarmListTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Const.Identifier.AlarmListTableViewCell)
    }
    
    private func goToAlarmListViewController(mode: AlarmListViewController.ListMode) {
        guard let alarmListViewController = UIStoryboard(name: Const.Storyboard.AlarmList, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.AlarmListViewController) as? AlarmListViewController else { fatalError() }
        alarmListViewController.mode = mode
        alarmListViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(alarmListViewController, animated: true)
    }
    
    // MARK: - IBAction
    @IBAction func moreLastAlarmButtonDidTap(_ sender: Any) {
        goToAlarmListViewController(mode: .last)
    }
    
    @IBAction func moreComingAlarmButtonDidTap(_ sender: Any) {
        goToAlarmListViewController(mode: .coming)
    }
}
