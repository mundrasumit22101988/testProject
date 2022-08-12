//
//  ViewModel.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import Foundation


protocol ViewModelDelegate: AnyObject {
    func viewModelDelegateDidGetPost(_ viewModel: ViewModel, state: ViewModel.State)
}

protocol ViewModelProtocol: Any {
    var numberOfRow: Int { get }
    var delegate: ViewModelDelegate? { get set }
    
    func getPostData()
    func getPost(at index: Int) -> PostModel?
    func getFilterPost(searchText: String)
}

class ViewModel: ViewModelProtocol {
    enum State: Equatable {
        case getData
        case filterData
        case error(message: String)
    }
    private var posts: Post = []
    private var filterPosts: Post = []
    var apiClient: APIClientProtocol?
    weak var delegate: ViewModelDelegate?
    
    var numberOfRow: Int {
        filterPosts.count
    }
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getPostData() {
        apiClient?.getPosts(completion: { post, error in
            guard let postArray = post else {
                self.delegate?.viewModelDelegateDidGetPost(self, state: .error(message: error?.errorMessage() ?? ""))
                return
            }
            
            self.posts = postArray
            self.filterPosts = postArray
            self.delegate?.viewModelDelegateDidGetPost(self, state: .getData)
        })
    }
    
    func getPost(at index: Int) -> PostModel? {
        guard index < filterPosts.count else {
            return nil
        }
        
        return filterPosts[index]
    }
    
    func getFilterPost(searchText: String) {
        if searchText.isEmpty {
            filterPosts = posts
        } else {
            filterPosts = posts.filter({ post in
                post.title.lowercased().contains(searchText) ||  post.body.lowercased().contains(searchText)
            })
        }
            
        self.delegate?.viewModelDelegateDidGetPost(self, state: .filterData)
    }
    
}

