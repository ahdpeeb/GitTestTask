//
//  LoadRepositoriesListViewModel.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RepositoriesListViewModel: ViewModel {
    func repositories() -> Observable<[Repository]> {
        let url = "https://api.github.com/user/repos"
        let options = ["sort": "created", "direction": "desc"]
        return self.loadAny(url: url, method: .get, parametres: options)
            .map({ (result) -> [Repository] in
                guard let jsonList = result as? [[String: Any]] else { return [] }
                var buffet = [Repository]()
                jsonList.forEach({ (json) in
                    Repository(JSON: json).map{ buffet.append($0) }
                })
                
                return buffet
            })
    }
}
