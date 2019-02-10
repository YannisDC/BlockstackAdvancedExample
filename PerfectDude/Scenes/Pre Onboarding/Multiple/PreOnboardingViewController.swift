//
//  PreOnboardingViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 05/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PreOnboardingViewController: ViewController {
    internal var viewModel: PreOnboardingViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let viewControllers: [UIViewController]
    fileprivate let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    fileprivate let startIndex: Int = 0
    fileprivate var previousIndex: Int = 0
    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: PreOnboardingViewController.className, bundle: nil)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutPageView()
    }
}

// MARK: - Navigation

private extension PreOnboardingViewController {
    func scrollToViewController(viewController: UIViewController, direction: UIPageViewController.NavigationDirection, animated: Bool) {
        pageViewController.setViewControllers([viewController], direction: direction, animated: animated, completion: nil)
        addChild(childViewController: pageViewController, on: containerView)
    }
    
    func layoutPageView() {
        if let firstViewController = viewControllers[safe: startIndex] {
            scrollToViewController(viewController: firstViewController, direction: .forward, animated: false)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension PreOnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let index = viewControllers.index(of: viewController),
            let viewController = viewControllers[safe: index - 1]
            else { return nil }
        
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let index = viewControllers.index(of: viewController),
            let viewController = viewControllers[safe: index + 1]
            else { return nil }
        
        return viewController
    }
}

// MARK: - UIPageViewControllerDelegate

extension PreOnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        return
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if (!completed) { return }
//        pageControl.currentPage = pageViewController.viewControllers!.first!.view.tag
        return
    }
}

extension PreOnboardingViewController: Bindable {

    func bindViewModel() {
        let input = PreOnboardingViewModel.Input(buttonTap: button.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.tapResult.drive().disposed(by: disposeBag)
        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
