//
//  HomeViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

class HomeViewController: BaseViewController {

    @IBOutlet weak private var titleView: UIView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var categoryCollectionView: UICollectionView!
    private var selectedCategoryView: UIView!
    private var pageViewController: UIPageViewController?
    private var currentIndex = 0
    private var lastIndex: NSIndexPath?
    private var padding: CGFloat = 10
    private var viewControllers: [ContentViewController] = []
    private var listCategory: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Life Cycle
    override func setUpUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        categoryCollectionView.registerNib(CategoryCell)
        selectedCategoryView = UIView(frame: CGRect(x: 0, y: 38, width: 148.5, height: 2))
        selectedCategoryView.backgroundColor = Color.BorderColor
        categoryCollectionView.addSubview(selectedCategoryView)
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
    }

    override func setUpData() {
        // Category.cleanData()
        Video.cleanData()
        if let categories = Category.getCategories() where categories.count > 0 {
            listCategory = categories
            loadData()
            addContentToPageViewController()
        } else {
            loadCategories()
        }
    }

    private func loadData() {
        listCategory = RealmManager.getAllCategory()
        categoryCollectionView.reloadData()
    }

    // MARK:- Private Function
    private func createViewController() {
        if let listCategory = listCategory {
            for index in 0..<listCategory.count {
                let viewController = ContentViewController()
                viewController.pageIndex = index
                viewController.pageId = listCategory[index].id
                viewControllers.append(viewController)
            }
        }

    }

    private func addContentToPageViewController() {
        createViewController()
        pageViewController = UIPageViewController(transitionStyle: .Scroll,
            navigationOrientation: .Horizontal, options: nil)
        pageViewController?.dataSource = self
        let viewController = viewControllers[0]
        pageViewController?.setViewControllers([viewController], direction: .Forward, animated: true, completion: nil)
        pageViewController?.view.frame = CGRect(x: contentView.bounds.minX,
            y: contentView.bounds.minY, width: contentView.bounds.width,
            height: contentView.bounds.height)
        addChildViewController(pageViewController!)
        contentView.addSubview((pageViewController?.view)!)
        pageViewController?.didMoveToParentViewController(self)

    }

    private func loadCategories() {
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet"
        parameters["regionCode"] = "VN"
        CategoryService.getVideoCatetogories(parameters) { (success, nextPageToken, error) in
            if success {
                self.loadData()
                self.addContentToPageViewController()
            } else {
                self.showAlert(Message.Title, message: Message.LoadCategoryFail, cancelButton: Message.OkButton)
            }
        }
    }

    private func backPage(viewController: UIViewController) {
        pageViewController?.setViewControllers([viewController], direction: .Forward, animated: true, completion: nil)
    }

    private func nextPage(viewController: UIViewController) {
        pageViewController?.setViewControllers([viewController], direction: .Reverse, animated: true, completion: nil)
    }

    // MARK:- Action
    @IBAction private func showSearchBar(sender: AnyObject) {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: false)
    }

}
//MARK:- Extension
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categories = listCategory {
            if categories.count > 10 {
                return 10
            } else {
                return categories.count
            }
        } else {
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeue(CategoryCell.self, forIndexPath: indexPath)
        let category = listCategory![indexPath.row]
        cell.configureCategoryCell(category)
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
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let category = listCategory![indexPath.row]
            let textLabel = UILabel()
            textLabel.text = category.title
            let labelTextWidth = textLabel.intrinsicContentSize().width
            return CGSize(width: labelTextWidth + padding * 2, height: collectionView.frame.height)
    }

}

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

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if let viewControl = pageViewController.viewControllers![0] as? ContentViewController {
                currentIndex = viewControl.pageIndex
                let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
                categoryCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
                let isSelected = currentIndex == indexPath.row ? true : false
                let selectedCell = collectionView(categoryCollectionView, cellForItemAtIndexPath: indexPath) as! CategoryCell
                selectedCell.changFont(isSelected)
                let frame = selectedCell.frame
                UIView.animateWithDuration(0.05) {
                    self.selectedCategoryView.frame = CGRect(x: frame.origin.x, y: 38, width: frame.size.width, height: 2)
                }
                currentIndex = indexPath.row
                categoryCollectionView.reloadSections(NSIndexSet(index: 0))
            }
    }
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if let viewControl = pageViewController.viewControllers![0] as? ContentViewController {
            currentIndex = viewControl.pageIndex
            let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
            categoryCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
            let isSelected = currentIndex == indexPath.row ? true : false
            let selectedCell = collectionView(categoryCollectionView, cellForItemAtIndexPath: indexPath) as! CategoryCell
            selectedCell.changFont(isSelected)
            let frame = selectedCell.frame
            UIView.animateWithDuration(0.05) {
                self.selectedCategoryView.frame = CGRect(x: frame.origin.x, y: 38, width: frame.size.width, height: 2)
            }
            currentIndex = indexPath.row
            categoryCollectionView.reloadSections(NSIndexSet(index: 0))
        }
    }
}

