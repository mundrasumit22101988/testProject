//
//  ViewController.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var viewModel: ViewModelProtocol  = ViewModel(apiClient: APIClient())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Posts"
        viewModel.delegate = self
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        
        showControllerActivity()
        DispatchQueue.global().async {
            self.viewModel.getPostData()
        }
    }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PostTableViewCell.identifier)", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        guard let post = viewModel.getPost(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.setData(for: post)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = viewModel.getPost(at: indexPath.row) else {
            return
        }
        
        let commentViewModel = CommentViewModel(apiClient: APIClient(), post: post)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let commentViewController = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController
        commentViewController?.viewModel = commentViewModel
        navigationController?.pushViewController(commentViewController ?? UIViewController(), animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.getFilterPost(searchText: searchText.lowercased())
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getFilterPost(searchText: searchBar.text?.lowercased() ?? "")
        tableView.reloadData()
        view.endEditing(true)
    }
}

extension ViewController: ViewModelDelegate {
    func viewModelDelegateDidGetPost(_ viewModel: ViewModel, state: ViewModel.State) {
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
