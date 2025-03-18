//
//  SettingViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//


import UIKit

final class SettingViewController: UIViewController {
    private let resetButton = UIButton()
    private var produceCollectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cv.backgroundColor = .green
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(produceCollectionView)
        view.addSubview(resetButton)
        
        produceCollectionView.delegate = self
        produceCollectionView.dataSource = self
        
        //버튼 레이아웃 설정
        resetButton.setTitle("전체 기록 삭제", for: .normal)
        resetButton.addTarget(self, action: #selector(resetAlert), for: .touchUpInside)
        resetButton.backgroundColor = .lightGray
        
        autoLayout()
        produceCollectionView.register(ProducerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    @objc func resetAlert() {
        //버튼이 눌리면 실행되는 부분(Alert)
        let alert = UIAlertController(title: "전체 기록 삭제", message: "모든 핀이 삭제됩니다.\n 진행하시겠습니까?", preferredStyle: .alert)

        let addAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                //저장된 내용이 지워지는 내용
                
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}

extension SettingViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //컬랙션 뷰의 셀 갯수
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProducerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .none
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //컬렉션 뷰의 셀의 크기
        let itemSpacing : CGFloat = 10
        
        let myWidth : CGFloat = (collectionView.bounds.width - itemSpacing * 2) / 2
        
        return CGSize(width: myWidth, height: 220)
    }
}

//오토레이아웃 제약 설정(snapkit) 부분
extension SettingViewController {
    private func autoLayout() {
        resetButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-90)
            $0.height.equalTo(50)
            $0.leading.equalTo(10)
        }
        //컬렉션 뷰 제약 설정 부분 예정
        produceCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(resetButton.snp.top).offset(-30)
        }
    }
}

#Preview {
    SettingViewController()
}
