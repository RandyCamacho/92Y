//
//  RecentsViewController.swift
//  app-92Y
//
//  Created by Randy Camacho on 11/18/20.
//

import UIKit
import JGProgressHUD

class RecentsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noRecentsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Recent Messages"
        label.textColor = .gray
        label.font = .systemFont(ofSize:21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newChat))
        view.addSubview(tableView)
        view.addSubview(noRecentsLabel)
        setupTableView()
        fetchRecents()
    }
    
    @objc private func newChat(){
        let vc = NewChatViewController()
        vc.completion = {[weak self]result in
            self?.createNewChat(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createNewChat(result: [String: String]) {
        guard let name = result["name"], let email = result["email"] else {
            return
        }
        let vc = ChatViewController(with: email)
        vc.isNewConversation = true
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchRecents() {
        tableView.isHidden = false
    }
}

extension RecentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Random User"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController(with: "text@email.com")
        vc.title = "Random User"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
