//
//  AlarmListViewController+Extension.swift
//  PhotoSurfer-iOS
//
//  Created by 김혜수 on 2022/07/18.
//

import UIKit

extension AlarmListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alarmSelectedPictureViewController = UIStoryboard(name: Const.Storyboard.Picture, bundle: nil)
                .instantiateViewController(withIdentifier: Const.ViewController.PictureViewController) as? PictureViewController else { return }
        alarmSelectedPictureViewController.type = .alarmSelected
        alarmSelectedPictureViewController.photoID = pushes[indexPath.item].photoID
        self.navigationController?.pushViewController(alarmSelectedPictureViewController, animated: true)
    }
}

extension AlarmListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pushes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Identifier.AlarmListTableViewCell, for: indexPath) as? AlarmListTableViewCell else { fatalError() }
        cell.setData(push: pushes[indexPath.row])
        return cell
    }
}
