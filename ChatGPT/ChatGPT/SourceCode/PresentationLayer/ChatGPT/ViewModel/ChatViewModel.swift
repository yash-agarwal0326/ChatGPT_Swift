//
//  ChatViewModel.swift
//  ChatGPT
//
//  Created by Yash Agarwal on 22/03/23.
//

import Foundation

class ChatViewModel: NSObject {
	
	var messageArray:[Message] = []
	
	func setup() {
		//Set-up open ai
		OpenAIApi.sharedInstance.setup()
	}
	
	///Get AI response
	func getAIResponse(fromMessage text:String, completion : @escaping ((String)->Void)) {
		OpenAIApi.sharedInstance.getResponse(inputMessage: text) { result in
			switch result {
			case .success(let output):
				completion(output)
			case .failure(let error):
				print(error)
			}
		}
	}
}
