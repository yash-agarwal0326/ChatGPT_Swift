//
//  UserTableViewCell.swift
//  ChatGPT
//
//  Created by Yash Agarwal on 22/03/23.
//

import UIKit

class UserTableViewCell: UITableViewCell {
	
	// MARK: - Outlets
	
	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var messageContainerView: UIView!
	
	// MARK: - Override Methods
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.selectionStyle = .none
		
		messageContainerView.layer.borderColor = UIColor.lightGray.cgColor
		messageContainerView.layer.borderWidth = 0.5
		messageContainerView.layer.cornerRadius = 10.0
	}
}
