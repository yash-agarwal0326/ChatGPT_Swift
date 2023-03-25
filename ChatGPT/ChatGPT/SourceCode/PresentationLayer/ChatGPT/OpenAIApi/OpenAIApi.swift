//
//  OpenAIApi.swift
//  ChatGPT
//
//  Created by Yash Agarwal on 25/03/23.
//

import Foundation
import OpenAISwift

class OpenAIApi {
	
	// Shared instance
	static let sharedInstance = OpenAIApi()
	
	// Private init
	private init() {}
	
	// OpenAISwift client
	private var client: OpenAISwift?
	
	///Setup client with chat gpt key
	func setup() {
		self.client = OpenAISwift(authToken: Constant.chat_gpt_key)
	}
	
	///Get response from the open ai for input message
	func getResponse(inputMessage: String, completion: @escaping (Result<String, Error>) -> Void) {
		client?.sendCompletion(with: inputMessage, completionHandler: { result in
			switch result {
			case .success(let model):
				let responseMessage = (model.choices.first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
				completion(.success(responseMessage))
			case .failure(let error):
				completion(.failure(error))
			}
		})
	}
	
}
