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
    private let datebutton = UIButton()   // leftbutton을 클래스 프로퍼티로 변경

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
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
        closeButton.alpha = 0.7 // 투명도 50% 설정

        self.view.addSubview(closeButton)

        // Auto Layout 설정
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)  // 상단에서 65포인트
            $0.trailing.equalToSuperview().offset(-5)  // 오른쪽에서 5
            $0.width.height.equalTo(40)  // 버튼 크기
        }
        
        //왼쪽 기록 날짜 버튼
        datebutton.backgroundColor = .clear
        datebutton.layer.cornerRadius = 10
        datebutton.setTitle("3월 17일", for: .normal)      //for: .normal은 아무런 상호작용 없을때 상태
        self.view.addSubview(datebutton)        //뷰에 leftbutton 보여줌
        datebutton.setTitleColor(UIColor.black, for: .normal) // 글자색을 검은색으로 변경
        
        //오토레이아웃 설정
        datebutton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10) //왼쪽에서 10 떨어짐
            $0.top.equalToSuperview().offset(300)   //탑에서 300
            $0.width.equalTo(180)       //너비 200
            $0.height.equalTo(30)         //높이 30
        }
        
        //오른쪽 날씨 버튼
        let weatherbutton = UIButton()
        weatherbutton.layer.cornerRadius = 10
        weatherbutton.setTitle("맑음", for: .normal)
        weatherbutton.setTitleColor(UIColor.black, for: .normal) // 글자색을 검은색으로 변경
        self.view.addSubview(weatherbutton)
        
        //오토레이아웃 설정
        weatherbutton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(210)
            $0.top.equalToSuperview().offset(300)
            $0.width.equalTo(180)
            $0.height.equalTo(30)
        }
        
        //그 아래 카메라 버튼
        let camerabutton = UIButton()
        camerabutton.backgroundColor = .white
        camerabutton.layer.cornerRadius = 75
        camerabutton.layer.shadowColor = UIColor.black.cgColor // 색깔
        camerabutton.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        camerabutton.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        camerabutton.layer.shadowRadius = 10 // 반경
        camerabutton.layer.shadowOpacity = 0.5
        if let cameraImage = UIImage(systemName: "camera.on.rectangle"){
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .default)
            let largeImage = cameraImage.withConfiguration(largeConfig)
            camerabutton.setImage(largeImage, for: .normal)
        }
        camerabutton.tintColor = UIColor(red: 96/255, green: 99/255, blue: 104/255, alpha: 1) // #606368 (다크 그레이)
        camerabutton.imageView?.contentMode = .scaleAspectFit
        
        camerabutton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)

        self.view.addSubview(camerabutton)
        //사진 배경 흰색, 안에 아이콘을 검은색
        
        // Auto Layout 설정
        camerabutton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(150)
            
        }
        
        // 배경 흰색, stroke를 회색
        // 제목 작성 버튼
        let titlefield = UITextField()
        titlefield.backgroundColor = .white
        titlefield.layer.borderColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).cgColor // #A9A9A9 (다크 라이트 그레이)
        titlefield.layer.borderWidth = 2 // 테두리 두께 설정
        titlefield.textColor = .black
        titlefield.layer.cornerRadius = 5
        titlefield.attributedPlaceholder = NSAttributedString(
            string: "제목 작성",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black] //제목작성 글자 흰색으로
        )
        titlefield.font = DesignSystemFont.Pretendard_Bold14
            .value
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
        contentTextView.backgroundColor = .white
        contentTextView.layer.borderColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).cgColor // #A9A9A9 (다크 라이트 그레이)
        contentTextView.layer.borderWidth = 2 // 테두리 두께 설정
        contentTextView.layer.cornerRadius = 5
        contentTextView.text = "남기고자 하는 메모가 있다면 작성해주세요."
        contentTextView.textAlignment = .center
        contentTextView.textColor = UIColor.black
        contentTextView.font = UIFont.systemFont(ofSize: 16)
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
        savebutton.backgroundColor = UIColor(red: 28/255, green: 70/255, blue: 245/255, alpha: 1) // #FF8C42 (딥 오렌지)
        savebutton.setTitle("저장", for: .normal)
        savebutton.layer.cornerRadius = 10
        self.view.addSubview(savebutton)
        
        //오토레이아웃 설정
        savebutton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(130)
            $0.top.equalToSuperview().offset(760)
            $0.width.equalTo(150)
            $0.height.equalTo(55)
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
    
    @objc func cameraButtonTapped() {
        let actionSheet = UIAlertController(title: "사진 선택", message: "사진을 가져올 방법을 선택하세요.", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }
        let galleryAction = UIAlertAction(title: "갤러리", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "남기고자 하는 메모가 있다면 작성해주세요." {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "남기고자 하는 메모가 있다면 작성해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
}

extension PinEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            // Handle the selected image (save, display, etc.)
            print("Selected Image: \(selectedImage)")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

#Preview{
    PinEditViewController()
}
