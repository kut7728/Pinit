//
//  CustomClusterAnnotationView.swift
//  Pinit
//
//  Created by 안정흠 on 3/21/25.
//

import UIKit
import MapKit

final class CustomClusterAnnotationView: MKMarkerAnnotationView {
    static let identifier = "CustomClusterAnnotationView"

    override var annotation: MKAnnotation? {
        didSet {
            configure()
        }
    }

    private func configure() {
        guard let cluster = annotation as? MKClusterAnnotation else { return }

        // 1️⃣ 클러스터 안에 있는 핀 개수 텍스트로 표시
        glyphText = "\(cluster.memberAnnotations.count)"
        markerTintColor = .systemBlue // 원하는 색
        displayPriority = .defaultHigh
    }
}
