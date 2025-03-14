//
//  PinEditViewController.swift
//  Pinit
//
//  Created by 안정흠이형메롱메롱메롱메롱바보바보바바바바보바보바보 on 3/12/25.
// 푸시할때 조심 씬델리게이트 바꿔라


import UIKit
import MapKit
import SnapKit

final class PinEditViewController: UIViewController {
    
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
        if let cameraImage = UIImage(systemName: "camera"){     //크기 조절 지피티
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
        
        let keyboardToolbar = UIToolbar()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneBtnClicked))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        keyboardToolbar.sizeToFit()
        
        titlefield.inputAccessoryView = keyboardToolbar
        
        
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
            view.frame.origin.y = -300
            // 키보드가 나타날 때 동작 (예: 뷰 위치 조정)
        }

        @objc func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0
            // 키보드가 사라질 때 동작
        }
    }

#Preview{
    PinEditViewController()
}


