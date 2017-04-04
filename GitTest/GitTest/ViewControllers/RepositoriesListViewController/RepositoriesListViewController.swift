//
//  RepositoriesListViewController.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RepositoriesListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var rootView: RepositoriesListView { return self.getView()! }
    let repositoriesViewModel = RepositoriesListViewModel()
    var repositories: [Repository]? {
        didSet{
            repositories.map({ _ in self.rootView.tableView.reloadData() })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfig()
        self.loadRepositories()
    }
    
    //MARK: Private func
    
    private func initialConfig() {
        let tableView =  self.rootView.tableView
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    private func loadRepositories() {
        self.rootView.isLoadingViewVisible = true
        self.repositoriesViewModel.repositories()
        .subscribe(onNext: { (repositories) in
            self.rootView.isLoadingViewVisible = false
            self.repositories = repositories
        }, onError: { (error) in
            self.rootView.isLoadingViewVisible = false
            print(error.localizedDescription)
        }).addDisposableTo(self.disposeBag)
    }
}

extension RepositoriesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cls: RepositoryCell.self, indexPath: indexPath)
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
