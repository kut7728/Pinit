//
//  PinDetailViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//


import UIKit
import SnapKit

// MARK: - Pin Detail Main View Controller
final class PinDetailViewController: UIViewController {
    private lazy var pinDetailView = PinDetailView()
    private lazy var pinReviewTableViewController = PinReviewTableViewController()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view = pinDetailView
        setupTableViewController()
    }
    
    private func setupTableViewController() {
//            addChild(pinReviewTableViewController)
            pinDetailView.reviewContainerView.addSubview(pinReviewTableViewController.view)
            pinReviewTableViewController.didMove(toParent: self)
        }
}

#Preview {
    PinDetailViewController()
}
