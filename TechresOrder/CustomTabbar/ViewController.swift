//
//  ViewController.swift
//  CustomTabBarExample
//
//  Created by Jędrzej Chołuj on 18/12/2021.
//

import UIKit

class ViewController: UIViewController {
    var router = CustomViewRouter()
    private let titleLabel = UILabel()
    private let item: CustomTabItem
    var viewModel = CustomViewModel()
    
    init(item: CustomTabItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupProperties()
        viewModel.bind(view: self, router: router)
        
        if(!ManageCacheObject.isLogin()){
            viewModel.makeLoginViewController()
        }
        
        titleLabel.textColor = .red
    }
    
    private func setupHierarchy() {
        view.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupProperties() {
        titleLabel.configureWith(item.name, color: .black, alignment: .center, size: 28, weight: .bold)
        view.backgroundColor = .white
    }
}