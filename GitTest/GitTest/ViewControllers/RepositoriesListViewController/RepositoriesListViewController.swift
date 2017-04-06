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
    var selectedRepository: Repository?
    var selectedBranch: String?
    
    var rootView: RepositoriesListView { return self.getView()! }
    let repositoriesViewModel = RepositoriesListViewModel()
    var repositories: [Repository]? {
        didSet{ repositories.map({ _ in self.rootView.tableView.reloadData() }) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfig()
        self.loadRepositories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommitsViewController", let controller = segue.destination as? CommitsViewController {
            guard let repository = self.selectedRepository, let brach = self.selectedBranch else {  return }
            controller.branch = brach
            controller.repository = repository
        }
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
    
    fileprivate func loadBranched(owner: String, repo: String) {
        self.repositoriesViewModel.loadBranches(owner: owner, repo: repo)
        .debug()
        .subscribe(onNext: { (branches) in
            let branches = branches.flatMap({ $0.name })
            self.presentBranchedActionSheet(branches: branches)
        }, onError: { (error) in
            print(error.localizedDescription)
        }).addDisposableTo(disposeBag)
    }
    
    private func presentBranchedActionSheet(branches: [String]) {
        let actionSheet = UIAlertController(title: "Branchs list", message: nil, preferredStyle: .actionSheet)
        branches.forEach { (branch) in
            let action = UIAlertAction(title: branch, style: .default, handler: { (action) in
                self.selectedBranch = branch
                self.performSegue(withIdentifier: "CommitsViewController", sender: self)
            })
            
            actionSheet.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension RepositoriesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cls: RepositoryCell.self, indexPath: indexPath)
        if let model = self.repositories?[indexPath.row] {
            cell.fillWithRepository(model)
            cell.showBranchesBlock = { button in
                guard let owner = model.owner?.login, let repo = model.name else { return }
                self.selectedRepository = model
                self.loadBranched(owner: owner, repo: repo)
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
