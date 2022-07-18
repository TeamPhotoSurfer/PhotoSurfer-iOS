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
}

extension AlarmListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Identifier.AlarmListTableViewCell, for: indexPath) as? AlarmListTableViewCell else { fatalError() }
        return cell
    }
}
