//
//  CommitsViewController.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/6/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import UIKit
import RxSwift

class CommitsViewController: UIViewController {
    public var repository: Repository!
    public var branch: String!
    
    private let disposeBag = DisposeBag()
    var rootView: CommitsRootView { return self.getView()! }
    private let viewModel = CommitsViewModel()
    fileprivate var commits: [Commit]? {
        didSet { self.rootView.tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfig()
        self.loadCommits()

    }
    
    private func initialConfig() {
        let tableView =  self.rootView.tableView
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    private func loadCommits() {
        guard let login = repository.owner?.login, let name = repository.name else { return }
        self.rootView.isLoadingViewVisible = true
        viewModel.loadCommits(owner: login, repo: name, branch: branch)
        .debug()
        .subscribe(onNext: { (commits: [Commit]) in
            self.rootView.isLoadingViewVisible = false
            self.commits = commits
        }, onError: { (error) in
            self.rootView.isLoadingViewVisible = false
        }).addDisposableTo(disposeBag)
    }
}

extension CommitsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cls: CommitCell.self, indexPath: indexPath)
        if let commit = self.commits?[indexPath.row] {
            cell.fillWithCommit(commit)
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
