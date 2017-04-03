//
//  PaginatorView.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/21/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

class PaginatorView: UIView {
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet var leftArrow: LeftArrowButton!
    @IBOutlet var rightArrow: RightArrowButton!
    @IBOutlet var curretPageLabel: UILabel!
    @IBOutlet var totalPagesLabel: UILabel!
    
    // You can change this property to display amount items in a table
    public var elementsOnPage = 5
    
    // Total elememts count in paginator, after you will set it, it will calculate totalPages
    public var elemtsCount: Int = 0 {
        didSet {
            let pagesCount = self.lastPage()
            self.totalPages.value = (pagesCount == 0) ? 1 : pagesCount
        }
    }
    
    public let currentPage = Variable<Int>(1)
    public let currentPageWithIndices = PublishSubject<CountableClosedRange<Int>>()
    public var totalPages = Variable<Int>(1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.totalPagesHasChanges()
        self.currentPageHasChanged()
    }
    
    //MARK: Initializations
    
    public static var paginator: PaginatorView { return UINib.view(PaginatorView.self)! }
    
    // Bind paginator view to superView bottom (), desirable height more than 45! offset can be with - (- 60)
    public func addToSuperViewBottom(_ view: UIView, withHeight height: CGFloat, withBottomOffset offset: CGFloat? = 0.0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let height = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
        
        let left = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        let right = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        let bottom = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: offset!)
        
        NSLayoutConstraint.activate([height, left, right, bottom])
        view.layoutSubviews()
    }
    
    // Automatic creates a paginator and adapts the size to superViewBound
    public static func paginatorViewOnSuperView(_ view: UIView) -> PaginatorView {
        let paginaror = self.paginator
        paginaror.frame = view.bounds
        paginaror.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin,
                                      .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        view.addSubview(paginaror)
        return paginaror
    }
    
    //MARK: Actions
    
    @IBAction func leftArrowAction(sender: UIButton) {
        let currentPage = self.currentPage.value
        self.currentPage.value = currentPage - 1
    }
    
    @IBAction func rightArrowAction(sender: UIButton) {
        let currentPage = self.currentPage.value
        self.currentPage.value = currentPage + 1
    }
    
    //MARK: Private functions
    
    private func lastPage() -> Int {
        let pages = self.elemtsCount / self.elementsOnPage
        return (elemtsCount % elementsOnPage == 0) ? pages : pages + 1
    }
    
    private func isLastPage(_ page: Int) -> Bool {
        return page == lastPage()
    }
    
    private func elementCountOnLastPage() -> Int {
        let balance = elemtsCount % elementsOnPage
        return balance == 0 ? elementsOnPage : balance
    }
    
    private func indicesForPage(_ page: Int) -> CountableClosedRange<Int>  {
        if self.isLastPage(page) {
            let count = self.elemtsCount
            return (count - self.elementCountOnLastPage())...(count - 1)
        } else {
            let count = page * elementsOnPage
            return (count - self.elementsOnPage)...(count - 1)
        }
    }
    
    //MARK: Private functions RXBinding
    
    private func totalPagesHasChanges() {
        let shareTotalPage = totalPages.asObservable().share()
        shareTotalPage.subscribe(onNext: { (totalPages) in
            if self.currentPage.value > totalPages {
                self.currentPage.value = totalPages
            } }).disposed(by: disposeBag)
        
        shareTotalPage.map({ return String($0) })
            .subscribe(self.totalPagesLabel.rx.text)
            .disposed(by: disposeBag)
        
        shareTotalPage.map({ $0 > self.currentPage.value })
        .subscribe(rightArrow.rx.isEnabled).addDisposableTo(disposeBag)
    }
    
    private func currentPageHasChanged() {
        let sharedPage = self.currentPage.asObservable()
        self.bindPageToLabel(page: sharedPage)
        self.disableLeftArrow(observable: sharedPage)
        self.disableRightArrow(observable: sharedPage)
        self.bindPage(page: sharedPage, to: self.currentPageWithIndices)
    }
    
    private func bindPageToLabel(page : Observable<Int>) {
        page.map({ return String($0) })
            .subscribe(self.curretPageLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func disableLeftArrow(observable: Observable<Int>) {
        observable.map { $0 > 1 }
        .subscribe(leftArrow.rx.isEnabled)
        .disposed(by: disposeBag)
    }
    
    private func disableRightArrow(observable: Observable<Int>) {
        observable.map { $0 < self.totalPages.value }
        .subscribe(rightArrow.rx.isEnabled)
        .disposed(by: disposeBag)
    }
    
    private func bindPage(page : Observable<Int>, to pageIndices: PublishSubject<CountableClosedRange<Int>>) {
        page.map { page -> CountableClosedRange<Int> in
                return self.indicesForPage(page)
            }
            .subscribe(pageIndices)
            .disposed(by: disposeBag)
    }
}
