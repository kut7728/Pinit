//
//  MainTabBarController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit
import CoreData

final class MainTabBarController: UITabBarController {
    private lazy var usecase: UseCase = {
        let container = NSPersistentContainer(name: "Pinit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // context.perform을 제대로 사용하기위해 백그라운드컨텍스트로 가져옴
        // 비동기 작업에 사용됌
        let context = container.newBackgroundContext()
        return UseCaseImpl(dbRepository: DBRepositoryImpl(context: context),
                    imageStore: ImageStoreRepositoryImpl())
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAppearance()
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        // set tabbar opacity
        appearance.configureWithOpaqueBackground()

        // remove tabbar border line
        appearance.shadowColor = UIColor.clear

        // set tabbar background color
        appearance.backgroundColor = .white

        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
                // set tabbar opacity
                tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }

        // set tabbar tintColor
        tabBar.tintColor = .black

        // set tabbar shadow
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 1, height: 10)
        tabBar.layer.shadowRadius = 10
    }
    
    private func setupViewControllers() {
        let home = UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "house"),
                                       selectedImage: UIImage(systemName: "house.fill"))
        
        let pastPin = UINavigationController(rootViewController: PastPinViewController())
        pastPin.tabBarItem = UITabBarItem(title: "PastPin",
                                       image: UIImage(systemName: "calendar"),
                                       tag: 1)
        
        let setting = UINavigationController(rootViewController: SettingViewController())
        setting.tabBarItem = UITabBarItem(title: "Setting",
                                          image: UIImage(systemName: "gearshape"),
                                          selectedImage: UIImage(systemName: "gearshape.fill"))
        
        self.setViewControllers([home, pastPin, setting], animated: true)
    }
}

#Preview {
    MainTabBarController()
}
