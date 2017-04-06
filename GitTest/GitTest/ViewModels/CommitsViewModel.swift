//
//  CommitsViewModel.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/6/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

class CommitsViewModel: ViewModel {
    func loadCommits(owner: String, repo: String, branch: String) -> Observable<[Commit]> {
        let url = "https://api.github.com/repos/\(owner)/\(repo)/commits"
        return self.loadAny(url: url, method: .get, parametres: ["sha": branch], encoding: URLEncoding.default)
        .map { (any) -> [Commit] in
            guard let jsons = any as? [[String: Any]] else { return [] }
            var commits = [Commit]()
            jsons.forEach({ (json) in
                Commit(JSON: json).map({ commits.append($0) })
            })
            
            return commits
        }
    }
}
