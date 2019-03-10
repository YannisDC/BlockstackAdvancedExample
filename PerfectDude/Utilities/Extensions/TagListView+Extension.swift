//
//  TagListView+Extension.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TagListView

extension TagListView: HasDelegate {
    public typealias Delegate = TagListViewDelegate
}

class RxTagListViewDelegateProxy: DelegateProxy<TagListView, TagListViewDelegate>, TagListViewDelegate, DelegateProxyType {
    init(parentObject: TagListView) {
        super.init(parentObject: parentObject, delegateProxy: RxTagListViewDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxTagListViewDelegateProxy(parentObject: $0) }
    }
}

//extension Reactive where Base: TagListView {
//    var delegate: RxTagListViewDelegateProxy {
//        return RxTagListViewDelegateProxy.proxy(for: base)
//    }
//
//    var didPressTagView: Observable<TagView> {
//        return delegate.methodInvoked(#selector(TagListViewDelegate.tagPressed(_:tagView:sender:)))
//            .map { $0[1] as! TagView }
//    }
//
//    var didRemoveTagView: Observable<TagView> {
//        return delegate.methodInvoked(#selector(TagListViewDelegate.tagRemoveButtonPressed(_:tagView:sender:)))
//            .map { $0[1] as! TagView }
//    }
//}



//let custom = CustomTagListView()
//custom.tagViews = [TagView(title: "yannis")]
//custom.rx.tagViews
//    .asDriver()
//    .do(onNext: { (list) in
//        print(list)
//    })
//    .drive()
//    .disposed(by: disposeBag)
//
//custom.tagViews = [TagView(title: "yannis"), TagView(title: "de"), TagView(title: "cleene")]

class CustomTagListView: UIControl {
    open weak var delegate: TagListViewDelegate?
    
    var tagViews: [TagView] = [] {
        didSet { sendActions(for: .valueChanged) } // You are missing this part
    }
}

extension CustomTagListView: HasDelegate {
    public typealias Delegate = TagListViewDelegate
}

class RxCustomTagListViewDelegateProxy: DelegateProxy<CustomTagListView, TagListViewDelegate>, TagListViewDelegate, DelegateProxyType {
    init(parentObject: CustomTagListView) {
        super.init(parentObject: parentObject, delegateProxy: RxCustomTagListViewDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxCustomTagListViewDelegateProxy(parentObject: $0) }
    }
}

extension Reactive where Base: TagListView {
    
    var delegate: RxTagListViewDelegateProxy {
        return RxTagListViewDelegateProxy.proxy(for: base)
    }
    
    
    var tagViewsValues: ControlProperty<[TagView]> {
        return base.rx.controlProperty(editingEvents: UIControlEvents.valueChanged,
                                       getter: { customView in return customView.tagViews }, // FIXME: Not getting the values yet
            setter: { (customView, newValue) in
                customView.removeAllTags() // FIXME: just filter out duplicates alright
                customView.addTags(newValue.map {$0.title(for: UIControl.State()) ?? ""})
        })
    }
    
    var didRemoveTagView: ControlEvent<TagView> {
        return ControlEvent<TagView>(events: delegate.methodInvoked(#selector(TagListViewDelegate.tagRemoveButtonPressed(_:tagView:sender:)))
            .map { ($0[1] as! TagView) })
    }
    
}


extension Reactive where Base: UIBarButtonItem {
    
    /// Bindable sink for `visible` property.
    public var isVisible: Binder<Bool> {
        return Binder(self.base) { element, value in
            element.tintColor = value ? .black : .clear
        }
    }
}


extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
