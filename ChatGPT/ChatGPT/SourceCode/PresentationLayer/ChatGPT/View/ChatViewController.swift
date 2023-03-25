//
//  ViewController.swift
//  ChatGPT
//
//  Created by Yash Agarwal on 09/03/23.
//

import UIKit

class ChatViewController: UIViewController {
	
	// MARK: - Instace Properties
	
	private let userInputTextField:UITextField = {
		let textField = UITextField()
		textField.backgroundColor = .clear
		textField.textColor = .white
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.attributedPlaceholder = NSAttributedString(
			string: "Type here ....",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
		)
		textField.returnKeyType = .done
		return textField
	}()
	
	private let userInputContainerView:UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		view.layer.cornerRadius = 25.0
		view.layer.borderWidth = 1.0
		view.layer.borderColor = UIColor.lightGray.cgColor
		return view
	}()
	
	private let chatTableView:UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()
	
	private let headerLabel:UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.text = "Chat GPT"
		label.font = UIFont.boldSystemFont(ofSize: 20.0)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var viewModel = ChatViewModel()
	
	// MARK: - Override Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		customUIForIntialLaunch()
		viewModel.setup()
	}
}

// MARK: - Fileprivate Methods

extension ChatViewController {
	
	// Custom ui for initial launch
	fileprivate func customUIForIntialLaunch() {
		view.backgroundColor = .black
		addViews()
		
		
	}
	
	// Add views
	fileprivate func addViews() {
		
		userInputTextField.delegate = self
		userInputContainerView.addSubview(userInputTextField)

		view.addSubview(userInputContainerView)
		
		chatTableView.dataSource = self
		chatTableView.backgroundColor = .clear
		view.addSubview(chatTableView)
		
		view.addSubview(headerLabel)
		
		addConstraints()
		registerNib()
	}
	
	// Register cell
	fileprivate func registerNib() {
		
		chatTableView.estimatedRowHeight = 100
		chatTableView.rowHeight = UITableView.automaticDimension
		
		let aiNib = UINib(nibName: "AITableViewCell", bundle: nil)
		chatTableView.register(aiNib, forCellReuseIdentifier: "AITableViewCell")
		
		let userNib = UINib(nibName: "UserTableViewCell", bundle: nil)
		chatTableView.register(userNib, forCellReuseIdentifier: "UserTableViewCell")
	}
	
	// Add constraints
	fileprivate func addConstraints() {
		
		NSLayoutConstraint.activate([
			userInputContainerView.heightAnchor.constraint(equalToConstant: 50),
			userInputContainerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0),
			userInputContainerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0),
			userInputContainerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10.0),
			
			userInputTextField.topAnchor.constraint(equalTo: userInputContainerView.topAnchor),
			userInputTextField.leftAnchor.constraint(equalTo: userInputContainerView.leftAnchor, constant: 10.0),
			userInputTextField.rightAnchor.constraint(equalTo: userInputContainerView.rightAnchor, constant: -10.0),
			userInputTextField.bottomAnchor.constraint(equalTo: userInputContainerView.bottomAnchor),
			
			chatTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10.0),
			chatTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0),
			chatTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0),
			chatTableView.bottomAnchor.constraint(equalTo: userInputContainerView.topAnchor, constant: -10.0),
			
			headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			headerLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
			headerLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
			headerLabel.heightAnchor.constraint(equalToConstant: 30.0)
		])
	}
}

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if !(textField.text?.isEmpty ?? true) {
			let text = (textField.text!).trimmingCharacters(in: .whitespacesAndNewlines)
			viewModel.messageArray.append(Message(owner: .user, text: text))
			chatTableView.reloadData()
			getAIResponse(forMessage: text)
			textField.text = ""
		}
		
		return textField.resignFirstResponder()
	}
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.messageArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = viewModel.messageArray[indexPath.row]
		
		if message.owner == .user {
			let cell = chatTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
			cell.messageLabel.text = message.text
			return cell
		}
		else {
			let cell = chatTableView.dequeueReusableCell(withIdentifier: "AITableViewCell", for: indexPath) as! AITableViewCell
			cell.messageLabel.text = message.text
			return cell
		}
	}
}

// MARK: - OpenAI

extension ChatViewController {
	
	///Get AI response from message text
	fileprivate func getAIResponse(forMessage text:String) {
		viewModel.getAIResponse(fromMessage: text) { [weak self] text in
			self?.viewModel.messageArray.append(Message(owner: .ai, text: text))
			DispatchQueue.main.async {
				self?.chatTableView.reloadData()
			}
		}
	}
}
