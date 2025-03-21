//
//  PinEditViewController.swift
//  Pinit
//
//  Created by 안정흠 on 3/12/25.
//  Edited by 안세훈 on 3/21/25 lol

import UIKit
import MapKit
import SnapKit

enum PinMode {
    case create(latitude: Double, longtitude: Double)
    case edit(PinEntity : PinEntity)
}

final class PinEditViewController: UIViewController, UITextViewDelegate {
    var pinEntity: PinEntity?
    var pinmode: PinMode?
    var isAdded: ((PinEntity) -> Void)? // 핀추가가 됐을때 호출되는 클로저 (홈에서만 사용)
    
    private var mapView: MKMapView = {
        let view = MKMapView()
        let center = CLLocationCoordinate2D(latitude: 37.506446, longitude: 126.885397)     //중심좌표
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        view.setRegion(region, animated: true)
        return view
    }()
    
    private let saveButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 28/255, green: 70/255, blue: 245/255, alpha: 1) // #FF8C42 (딥 오렌지)
        button.setTitle("저장", for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let contentTextView : UITextView = {
        let textview = UITextView()
        textview.backgroundColor = .white
        textview.layer.borderColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).cgColor // #A9A9A9 (다크 라이트 그레이)
        textview.layer.borderWidth = 2 // 테두리 두께 설정
        textview.layer.cornerRadius = 5
        textview.text = "남기고자 하는 메모가 있다면 작성해주세요."
        textview.textAlignment = .center
        textview.textColor = UIColor.black
        textview.font = UIFont.systemFont(ofSize: 16)
        return textview
    }()
    
    private let titleTextField : UITextField = {
        let textfield = UITextField()
        textfield.layer.borderColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).cgColor
        textfield.layer.borderWidth = 2
        textfield.textColor = .black
        textfield.layer.cornerRadius = 5
        textfield.attributedPlaceholder = NSAttributedString(
            string: "제목 작성",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textfield.font = DesignSystemFont.Pretendard_Bold14
            .value
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textfield.leftViewMode = .always
        return textfield
    }()
    
    private let cameraButton : UIButton = {
        let button = UIButton()
        //MARK: 아래 카메라 버튼
        button.backgroundColor = .white
        button.layer.cornerRadius = 75
        button.layer.shadowColor = UIColor.black.cgColor // 색깔
        button.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        button.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        button.layer.shadowRadius = 10 // 반경
        button.layer.shadowOpacity = 0.5
        
        if let cameraImage = UIImage(systemName: "camera.on.rectangle"){
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .default)
            let largeImage = cameraImage.withConfiguration(largeConfig)
            button.setImage(largeImage, for: .normal)
        }
        button.tintColor = UIColor(red: 96/255, green: 99/255, blue: 104/255, alpha: 1)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let weatherButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("맑음", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal) // 글자색을 검은색으로 변경
        return button
    }()
    
    private let dateButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.setTitle("3월 17일", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private let closeButton : UIButton = {
        let button = UIButton()
        //MARK: 지도 오른쪽 위에 닫기 버튼 추가, xmark.circle.fill
        if let closeImage = UIImage(systemName: "xmark.circle.fill") {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .default)
            let largeImage = closeImage.withConfiguration(largeConfig)
            button.setImage(largeImage, for: .normal)
        }
        button.tintColor = .black
        button.alpha = 0.7 // 투명도 50% 설정
        return button
    }()
    
    private let keyboardToolBar: UIToolbar = {
        let toolbar = UIToolbar()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: "완료", style: .plain, target: PinEditViewController.self, action: #selector(doneBtnClicked))
        toolbar.items = [flexBarButton, doneBarButton]
        toolbar.sizeToFit()
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetUI()
        SetMap()
        viewmode()
        setUpKeyboard()
    }
    
    
    func viewmode(){
        switch pinmode {
        case let .create(latitude, longtitude):
            print("\(latitude), \(longtitude)")
            pinEntity = PinEntity(pin_id: UUID(),
                                  title: "",
                                  latitude: latitude, longitude: longtitude,
                                  address: "",
                                  date: Date(),
                                  weather: "",
                                  description: "",
                                  mediaPath: nil)
        case let .edit(PinEntity):
            print(PinEntity)
            self.pinEntity = PinEntity
            print("편집 모드입니다")
        case .none:
            print("?")
        }
    }
    
    private func SetUI() {
        titleTextField.inputAccessoryView = keyboardToolBar
        contentTextView.inputAccessoryView = keyboardToolBar
        contentTextView.delegate = self
        
        closeButton.addTarget(PinEditViewController.self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cameraButton.addTarget(PinEditViewController.self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        self.view.addSubviews(mapView, saveButton, contentTextView, titleTextField, cameraButton, weatherButton, dateButton, closeButton)
        
        saveButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(130)
            $0.top.equalToSuperview().offset(760)
            $0.width.equalTo(150)
            $0.height.equalTo(55)
        }
        contentTextView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.width.equalTo(360)
            $0.height.equalTo(150)
        }
        titleTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(540)
            $0.width.equalTo(360)
            $0.height.equalTo(40)
        }
        cameraButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        weatherButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(210)
            $0.top.equalToSuperview().offset(300)
            $0.width.equalTo(180)
            $0.height.equalTo(30)
        }
        dateButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(300)
            $0.width.equalTo(180)
            $0.height.equalTo(30)
        }
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)
            $0.trailing.equalToSuperview().offset(-5)
            $0.width.height.equalTo(40)
        }
    }
    
    private func SetMap(){
        mapView = MKMapView(frame: self.view.bounds)
        mapView = MKMapView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height / 4))
    }
    
    //MARK: 저장버튼 눌림
    @objc private func saveButtonTapped() {
        guard let newPin = pinEntity else { return }
        isAdded?(newPin)
        dismiss(animated: true)
    }
    
    //MARK: 키보드 닫기
    @objc func doneBtnClicked() {
        view.endEditing(true)
    }
    
    //MARK: 카메라 선택, 사진 선택
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
    
    //MARK: 사진 선택하면 화면에 사진 띄우기
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: 시스템에 알리는 키보드 상태 알림
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
    
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
    //MARK: 키보드가 나타낼때 화면을 -300
    @objc func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -300
    }
    
    //MARK: 키보드가 사라질 때 동작
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    //MARK: 사용자가 텍스트뷰에 입력을 시작할 때 기본 안내 문구
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "남기고자 하는 메모가 있다면 작성해주세요." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    //MARK: 텍스트뷰가 비어있을 때 안내 메시지를 다시 표시
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "남기고자 하는 메모가 있다면 작성해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
}

//MARK: PinEditViewController 내에서 사진 선택 기능을 쉽게 사용
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
