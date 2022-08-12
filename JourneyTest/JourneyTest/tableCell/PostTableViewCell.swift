//
//  PostTableViewCell.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var body: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(for post: PostModel) {
        title.text = post.title
        body.text = post.body
    }
    
    func setData(for comment: CommentModel) {
        title.text = comment.name
        body.text = comment.body
    }
}
