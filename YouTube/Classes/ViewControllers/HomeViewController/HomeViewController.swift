//
//  HomeViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import SwiftUtils

class HomeViewController: BaseViewController {

    @IBOutlet weak private var searchView: UIView!
    @IBOutlet weak private var serachTextField: UITextField!
    @IBOutlet weak private var titleView: UIView!

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    private var selectedCategoryView: UIView!
    private var isShowSearchBar = false
    private var pageViewController: UIPageViewController?
    private var currentIndex = 0
    var lastIndex: NSIndexPath?
    var viewControllers: [ContentViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func configureHomeViewController() {
        self.categoryCollectionView.registerNib(CategoryCell)
    }

    override func setUpUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        configureHomeViewController()
        self.selectedCategoryView = UIView(frame: CGRect(x: 0, y: 38, width: 70, height: 2))
        self.selectedCategoryView.backgroundColor = UIColor.init(hex: 0xCC181E)
        self.categoryCollectionView.addSubview(selectedCategoryView)
        for i in 0...9 {
            let viewController = ContentViewController()
            viewController.pageIndex = i
            viewControllers.append(viewController)
        }
        addContent()
    }

    override func setUpData() {
        pageViewController?.dataSource = self
        pageViewController?.delegate = self

    }
    // MARK:- Add Page Controller

    private func addContent() {
        pageViewController = UIPageViewController(transitionStyle: .Scroll,
            navigationOrientation: .Horizontal, options: nil)
        pageViewController?.dataSource = self
        let viewController = viewControllers[0]
        pageViewController?.setViewControllers([viewController], direction: .Forward, animated: true, completion: nil)
        pageViewController?.view.frame = CGRect(x: contentView.bounds.minX,
            y: contentView.bounds.minY, width: contentView.bounds.width, height: contentView.bounds.height)
        addChildViewController(pageViewController!)
        contentView.addSubview((pageViewController?.view)!)
        pageViewController?.didMoveToParentViewController(self)

    }
    // MARK:- Show SearchBar
    @IBAction private func showSearchBar(sender: AnyObject) {
        self.searchView.hidden = isShowSearchBar
        self.titleView.hidden = !isShowSearchBar
        self.isShowSearchBar = !isShowSearchBar
    }
    // MARK:- Move Page
    func backPage(viewController: UIViewController) {

        pageViewController?.setViewControllers([viewController], direction: .Forward, animated: true, completion: nil)
    }

    func nextPage(viewController: UIViewController) {

        pageViewController?.setViewControllers([viewController], direction: .Reverse, animated: true, completion: nil)
    }

    private func loadCategories() {
        MyCategory.getVideoCatetogories { (success, error) in
            if success {
                self.setUpData()
            } else {

            }
        }
    }
}
//MARK:- UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.categoryCollectionView.dequeue(CategoryCell.self, forIndexPath: indexPath)
        cell.configureCategoryCell()
        let isSelected = currentIndex == indexPath.row ? true : false
        cell.changFont(isSelected)
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != currentIndex {
            if let selectedCell = categoryCollectionView.cellForItemAtIndexPath(indexPath) as? CategoryCell {
                let frame = selectedCell.frame
                UIView.animateWithDuration(0.3) {
                    self.selectedCategoryView.frame = CGRect(x: frame.origin.x, y: 38, width: frame.size.width, height: 2)
                }

                pageViewController?.delegate = self
                let viewController = viewControllers[indexPath.row]
                if currentIndex > indexPath.row {
                    nextPage(viewController)
                } else {
                    backPage(viewController)
                }
            }
            currentIndex = indexPath.row
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
    }
}
//MARK:- UIPageViewControllerDataSource
extension HomeViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            var index = (viewController as? ContentViewController)!.pageIndex
            if (index == 0) || (index == NSNotFound) {
                return nil
            }
            index = index - 1
            return viewControllers[index]
    }

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            var index = (viewController as? ContentViewController)!.pageIndex
            if index == NSNotFound {
                return nil
            }
            index = index + 1
            if index == 10 {
                return nil
            }
            return viewControllers[index]
    }
}
//MARK:- UIPageViewControllerDelegate
extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

            if let viewControl = pageViewController.viewControllers![0] as? ContentViewController {
                currentIndex = viewControl.pageIndex
                let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
                categoryCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
                let selectedCell = collectionView(categoryCollectionView, cellForItemAtIndexPath: indexPath)
                let frame = selectedCell.frame
                UIView.animateWithDuration(0.05) {
                    self.selectedCategoryView.frame = CGRect(x: frame.origin.x, y: 38, width: frame.size.width, height: 2)
                }
            }

    }

}

