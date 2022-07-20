//
//  AlarmViewController.swift
//  PhotoSurfer-iOS
//
//  Created by 김하늘 on 2022/07/10.
//

import UIKit

final class AlarmViewController: UIViewController {
    
    // MARK: - Property
    var todayAlarms: [Push] = []
    var tomorrowAlarms: [Push] = []
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var lastAlarmCountLabel: UILabel!
    @IBOutlet weak var commingAlarmCountLabel: UILabel!
    @IBOutlet weak var todayAlarmCountLabel: UILabel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPushToday()
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
    
    private func getPushToday() {
        PushService.shared.getPushListToday { [weak self] response in
            switch response {
            case .success(let data):
                guard let data = data as? PushTodayResponse else { return }
                self?.todayAlarms = data.today.push
                self?.tomorrowAlarms = data.tomorrow.push
                self?.lastAlarmCountLabel.text = "\(data.lastCount)"
                self?.commingAlarmCountLabel.text = "\(data.comingCount)"
                self?.todayAlarmCountLabel.text = "\(data.todayTomorrowCount)"
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
    
    // MARK: - IBAction
    @IBAction func moreLastAlarmButtonDidTap(_ sender: Any) {
        goToAlarmListViewController(mode: .last)
    }
    
    @IBAction func moreComingAlarmButtonDidTap(_ sender: Any) {
        goToAlarmListViewController(mode: .coming)
    }
}
