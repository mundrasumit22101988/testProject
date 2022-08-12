//
//  CommentViewModel.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import Foundation

protocol CommentViewModelDelegate: AnyObject {
    func commentViewModelDelegateDidGetComment(_ viewModel: CommentViewModel, state: ViewModel.State)
}

protocol CommentViewModelProtocol: Any {
    var numberOfSection: Int { get }
    var post: PostModel? { get }
    var heightForHeader: Float { get }
    var delegate: CommentViewModelDelegate? { get set }
    
    func getCommentData()
    func getComment(at index: Int) -> CommentModel?
    func getFilterComment(searchText: String)
    func titleForHeader(at section: Int) -> String
    func numberOfRow(at section: Int) -> Int
}

class CommentViewModel: CommentViewModelProtocol {
    enum State: Equatable {
        case getData
        case filterData
        case error(message: String)
    }
    
    private var comment: Comment = []
    private var filterComment: Comment = []
    var post: PostModel?
    var apiClient: APIClientProtocol?
    
    weak var delegate: CommentViewModelDelegate?
   
    var numberOfSection: Int {
        return 2
    }
    
    var heightForHeader: Float {
        24.0
    }
    
    init(apiClient: APIClientProtocol, post: PostModel) {
        self.apiClient = apiClient
        self.post = post
    }
    
    func getCommentData() {
        guard let postID = post?.id else {
            return
        }
        
        apiClient?.getComment(postID: "\(postID)", completion: { comment, error in
            guard let commentArray = comment else {
                self.delegate?.commentViewModelDelegateDidGetComment(self, state: .error(message: error?.errorMessage() ?? ""))
                return
            }
            
            self.comment = commentArray
            self.filterComment = self.comment
            self.delegate?.commentViewModelDelegateDidGetComment(self, state: .getData)
        })
    }
    
    func getComment(at index: Int) -> CommentModel? {
        guard index < filterComment.count else {
            return nil
        }
        
        return filterComment[index]
    }
    
    func getFilterComment(searchText: String) {
        if searchText.isEmpty {
            filterComment = comment
        } else {
            filterComment = comment.filter({ post in
                post.body.lowercased().contains(searchText)
            })
        }
            
        self.delegate?.commentViewModelDelegateDidGetComment(self, state: .filterData)
    }
    
    func titleForHeader(at section: Int) -> String {
        section == 1 ? "Comments" : "Post Information"
    }
    
    func numberOfRow(at section: Int) -> Int {
        section == 0 ? 1 : filterComment.count
    }
}

