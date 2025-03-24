//
//  SettingViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//

import UIKit

final class SettingViewController: UIViewController {
    var data: [PinEntity] = PinEntity.producerData
    //모델에서 데이터를 가져옴
    
    private let resetButton = UIButton()
    private var produceCollectionView : UICollectionView = {
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        let spacing = 5.0
        var width: CGFloat = UIScreen.main.bounds.width
        width = (width / 2) - (spacing * 1.5)
        layout.itemSize = .init(width: width, height: width * 1.23)
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = .init(top: 0, left: spacing, bottom: spacing, right: spacing)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(produceCollectionView)
        view.addSubview(resetButton)
        
        produceCollectionView.delegate = self
        produceCollectionView.dataSource = self
        produceCollectionView.backgroundColor = .secondarySystemBackground
        
        //버튼 레이아웃 설정
        resetButton.setTitle("전체 기록 삭제", for: .normal)
        resetButton.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        resetButton.addTarget(self, action: #selector(resetAlert), for: .touchUpInside)
        
        resetButton.setTitleColor(.white, for: .normal)
        
        resetButton.backgroundColor = DesignSystemColor.Purple.value
        resetButton.layer.cornerRadius = 10
        
        resetButton.layer.masksToBounds = false
        //resetButton.layer.shadowOpacity = 0.5
        //resetButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        autoLayout()
        produceCollectionView.register(ProducerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    @objc func resetAlert() {
        //버튼이 눌리면 실행되는 부분(Alert)
        let alert = UIAlertController(title: "전체 기록 삭제", message: "모든 핀이 삭제됩니다.\n 진행하시겠습니까?", preferredStyle: .alert)

        let addAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                //1.저장된 내용이 지워지는 내용
                
                //2.삭제되었습니다
                
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}

extension SettingViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PinDetailViewController(PinEntity.producerData[indexPath.row], isPin: false) //프로필 누르면 상세 화면으로
        
        present(detailVC, animated: true ,completion: nil )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //컬랙션 뷰의 셀 갯수
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProducerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: data[indexPath.row])
        
        
        return cell
    }
    
}

//오토레이아웃 제약 설정(snapkit) 부분
extension SettingViewController {
    private func autoLayout() {
        resetButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        //컬렉션 뷰 제약 설정 부분 예정
        produceCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(resetButton.snp.top).offset(-10)
        }
    }
}

#Preview {
    SettingViewController()
}
