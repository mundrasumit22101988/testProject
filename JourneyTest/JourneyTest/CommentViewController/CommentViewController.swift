//
//  CommentViewController.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var viewModel: CommentViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Post Detail"
        viewModel?.delegate = self
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        
        showControllerActivity()
        DispatchQueue.global().async {
            self.viewModel?.getCommentData()
        }
    }
}


extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 16, y: 0, width: 320, height: 24)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.text = viewModel?.titleForHeader(at: section)
        let headerView = UIView()
        headerView.addSubview(headerLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.heightForHeader ?? 0.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRow(at: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PostTableViewCell.identifier)", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            guard let post = viewModel?.post else {
                return UITableViewCell()
            }
            
            cell.setData(for: post)
            
        case 1:
            guard let comment = viewModel?.getComment(at: indexPath.row) else {
                return UITableViewCell()
            }
            
            cell.setData(for: comment)
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}

extension CommentViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getFilterComment(searchText: searchText.lowercased())
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.getFilterComment(searchText: searchBar.text?.lowercased() ?? "")
        tableView.reloadData()
        view.endEditing(true)
    }
}

extension CommentViewController: CommentViewModelDelegate {
    func commentViewModelDelegateDidGetComment(_ viewModel: CommentViewModel, state: ViewModel.State) {
        DispatchQueue.main.async {
            self.stopControllerActivity()
            switch state {
            case .getData, .filterData:
                self.tableView.reloadData()
            case let .error(message):
                CommonMethod.showAlert(alert: message, delegate: self)
            }
        }
       
    }
}
