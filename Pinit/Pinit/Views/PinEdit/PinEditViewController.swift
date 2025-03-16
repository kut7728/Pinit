//
//  PinEditViewController.swift
//  Pinit
//
//  Created by 안정흠이형메롱메롱메롱메롱바보바보바바바바보바보바보 on 3/12/25.
// 푸시할때 조심 씬델리게이트 바꿔라


import UIKit
import MapKit
import SnapKit

final class PinEditViewController: UIViewController, UITextViewDelegate {
    
    private var mapView: MKMapView!     //mapview 불러옴
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white      //시뮬레이터 돌려보니 검은색 나와서 흰색으로 했ㄷ
        
        mapView = MKMapView(frame: self.view.bounds)    //mkmapview 초기화 및 뷰 추가함
        mapView = MKMapView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height / 4)) //화면의 1/4만 나오게 함
        
        self.view.addSubview(mapView)       //mapview 뷰에 보이게 합니다다아암;ㄹㅇ너리ㅏ머
        
        setUpKeyboard()
        
        let center = CLLocationCoordinate2D(latitude: 37.506446, longitude: 126.885397)     //중심좌표
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        
        
        // 지도 오른쪽 위에 닫기 버튼 추가, xmark.circle.fill
        let closeButton = UIButton(type: .system)
        if let closeImage = UIImage(systemName: "xmark.circle.fill") {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .default)
            let largeImage = closeImage.withConfiguration(largeConfig)
            closeButton.setImage(largeImage, for: .normal)
        }
        closeButton.tintColor = .black

        self.view.addSubview(closeButton)

        // Auto Layout 설정
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)  // 상단에서 65포인트
            $0.trailing.equalToSuperview().offset(-5)  // 오른쪽에서 20포인트
            $0.width.height.equalTo(40)  // 버튼 크기
        }
        
        //왼쪽 기록 날짜 버튼
        let leftbutton = UIButton()
        leftbutton.backgroundColor = .systemPink        //색 핑크임
        leftbutton.setTitle("기록 날짜", for: .normal)      //for: .normal은 아무런 상호작용 없을때 상태
        self.view.addSubview(leftbutton)        //뷰에 leftbutton 보여줌
        
        //오토레이아웃 설정
        leftbutton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10) //왼쪽에서 10 떨어짐
            $0.top.equalToSuperview().offset(300)   //탑에서 300
            $0.width.equalTo(190)       //너비 200
            $0.height.equalTo(30)         //높이 30
        }
        
        //오른쪽 날씨 버튼
        let rightbutton = UIButton()
        rightbutton.backgroundColor = .systemPink
        rightbutton.setTitle("날씨", for: .normal)
        self.view.addSubview(rightbutton)
        
        //오토레이아웃 설정
        rightbutton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(230)
            $0.top.equalToSuperview().offset(300)
            $0.width.equalTo(160)
            $0.height.equalTo(30)
        }
        
        //그 아래 카메라 버튼
        let camerabutton = UIButton()
        camerabutton.backgroundColor = .systemPink
        camerabutton.layer.cornerRadius = 10    //굴곡 10 넣음
        camerabutton.layer.shadowColor = UIColor.black.cgColor // 색깔
        camerabutton.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        camerabutton.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        camerabutton.layer.shadowRadius = 10 // 반경
        camerabutton.layer.shadowOpacity = 0.3
        if let cameraImage = UIImage(systemName: "camera"){
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular, scale: .default)
            let largeImage = cameraImage.withConfiguration(largeConfig)
            camerabutton.setImage(largeImage, for: .normal)
        }
        camerabutton.tintColor = .white
        camerabutton.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(camerabutton)
        
        // Auto Layout 설정
        camerabutton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(150)
            
        }
        
        // 제목 작성 버튼
        let titlefield = UITextField()
        titlefield.backgroundColor = .systemPink
        titlefield.textColor = .white
        titlefield.attributedPlaceholder = NSAttributedString(
            string: "제목 작성",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] //제목작성 글자 흰색으로
        )
        titlefield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))  // 이거 개쩜 제목 작성 맨 앞에 여백을 주는거임
        titlefield.leftViewMode = .always      //항상
        
        self.view.addSubview(titlefield)
        
        titlefield.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(540)
            $0.width.equalTo(360)
            $0.height.equalTo(40)
        }
        
        // 추가메모 텍스트뷰 추가
        let contentTextView = UITextView()
        contentTextView.backgroundColor = .systemPink
        contentTextView.textColor = .white
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1

        self.view.addSubview(contentTextView)

        contentTextView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(titlefield.snp.bottom).offset(10)
            $0.width.equalTo(360)
            $0.height.equalTo(150)
        }
        
        contentTextView.delegate = self
        
        //저장 버튼
        let savebutton = UIButton()
        savebutton.backgroundColor = .systemPink
        savebutton.setTitle("저장", for: .normal)
        self.view.addSubview(savebutton)
        
        //오토레이아웃 설정
        savebutton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(120)
            $0.top.equalToSuperview().offset(750)
            $0.width.equalTo(170)
            $0.height.equalTo(70)
        }
        
        
        //키보드 완료 버튼
        let keyboardToolbar = UIToolbar()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneBtnClicked))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        keyboardToolbar.sizeToFit()
        
        titlefield.inputAccessoryView = keyboardToolbar
        contentTextView.inputAccessoryView = keyboardToolbar
        
    }
    
    @objc func doneBtnClicked() {
        view.endEditing(true)  // 키보드 닫기
    }
    
    
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -300   //키보드가 나타날 때 동작
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0     //키보드가 사라질 때 동작
    }
}

#Preview{
    PinEditViewController()
}
