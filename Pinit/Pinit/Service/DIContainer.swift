//
//  DIContainer.swift
//  Pinit
//
//  Created by 안정흠 on 3/18/25.
//

import Foundation
import CoreData
import Moya

final class DIContainer: NSObject {
    static let service: Service = {
        let container = NSPersistentContainer(name: "Pinit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // context.perform을 제대로 사용하기위해 백그라운드컨텍스트로 가져옴
        // 비동기 작업에 사용됌
        let context = container.newBackgroundContext()
        return ServiceImpl(
            dbRepository: DBRepositoryImpl(context: context),
            imageStore: ImageStoreRepositoryImpl(),
            moyaProvider: MoyaProvider<Router>()
        )
    }()
}
