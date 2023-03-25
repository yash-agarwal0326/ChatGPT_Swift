//
//  Message.swift
//  ChatGPT
//
//  Created by Yash Agarwal on 25/03/23.
//

import Foundation

@frozen enum Owner {
	case user
	case ai
}

struct Message {
	var owner:Owner
	var text:String
}
