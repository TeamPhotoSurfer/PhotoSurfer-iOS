//
//  AlarmViewController+Extension.swift
//  PhotoSurfer-iOS
//
//  Created by κΉνμ on 2022/07/18.
//

import UIKit

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alarmSelectedViewController = UIStoryboard(name: Const.Storyboard.Picture, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.PictureViewController) as? PictureViewController else { return }
        alarmSelectedViewController.type = .alarmSelected
        alarmSelectedViewController.photoID = indexPath.section == 0 ? todayAlarms[indexPath.item].photoID : tomorrowAlarms[indexPath.item].photoID
        alarmSelectedViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(alarmSelectedViewController, animated: true)
    }
}

extension AlarmViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return todayAlarms.count
        case 1:
            return tomorrowAlarms.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Identifier.AlarmListTableViewCell, for: indexPath) as? AlarmListTableViewCell else { fatalError() }
        cell.setData(push: indexPath.section == 0 ? todayAlarms[indexPath.row] : tomorrowAlarms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return AlarmListSectionHeaderView(title: section == 0 ? "μ€λ" : "λ΄μΌ")
    }
}

extension AlarmViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        statusBarBackgroundView.isHidden = scrollView.contentOffset.y < 10
    }
}
