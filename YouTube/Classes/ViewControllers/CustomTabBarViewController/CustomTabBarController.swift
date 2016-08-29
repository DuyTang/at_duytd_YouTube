//
//  CustomTabBarController.swift
//  YouTube
//
//  Created by Duy Tang on 8/29/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import SnapKit

class CustomTabBarController: BaseTabbarViewController {
    
    private let tabbarView = (TabBarView.loadBundle() as? TabBarView)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.hidden = true
        view.addSubview(tabbarView)
        tabbarView.delegate = self
        tabbarView.snp_makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(60)
        }
        tabbarView.index = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CustomTabBarController: TabBarViewDelegate {
    func tabBarView(tabBar: TabBarView, didSelectIndex index: Int) {
        selectedIndex = index
    }
}
