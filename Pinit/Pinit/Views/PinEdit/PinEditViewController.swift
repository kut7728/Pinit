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
    case create(latitude: Double, longitude: Double)
    case edit(PinEntity : PinEntity)
}

final class PinEditViewController: UIViewController {
    private var pinEntity: PinEntity!
    var isAdded: ((PinEntity) -> Void)? // 핀추가가 됐을때 호출되는 클로저 (홈에서만 사용)
    private var pickedImage: UIImage?
    private var service = DIContainer.service
    private var mapView: MKMapView!
    
    private let saveButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.Purple.value // #FF8C42 (딥 오렌지)
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.layer.cornerRadius = 10
        return button
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.borderColor = DesignSystemColor.Lavender10.value.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 5
        textView.text = "남기고자 하는 메모가 있다면 작성해주세요."
        textView.tintColor = DesignSystemColor.Purple.value
        textView.textAlignment = .left
        textView.textColor = UIColor.lightGray
        textView.font = DesignSystemFont.Pretendard_Bold14.value
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.spellCheckingType = .no
        
        // Add padding here
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return textView
    }()
    
    private let titleTextField : UITextField = {
        let textfield = UITextField()
        textfield.layer.borderColor =  DesignSystemColor.Lavender10.value.cgColor
        textfield.tintColor = DesignSystemColor.Purple.value
        textfield.layer.borderWidth = 2
        textfield.textColor = .black
        textfield.layer.cornerRadius = 5
        textfield.attributedPlaceholder = NSAttributedString(
            string: "제목을 작성해주세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textfield.font = DesignSystemFont.Pretendard_Bold14.value
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textfield.leftViewMode = .always
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.spellCheckingType = .no
        return textfield
    }()
    
    private let cameraButton : UIButton = {
        let button = UIButton()
        //MARK: 아래 카메라 버튼
        button.backgroundColor = .white
        button.layer.cornerRadius = 75
        button.layer.shadowColor = DesignSystemColor.Purple.value.cgColor // 색깔
        button.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        button.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        button.layer.shadowRadius = 10 // 반경
        button.layer.shadowOpacity = 0.5
        
        if let cameraImage = UIImage(systemName: "camera.on.rectangle"){
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .default)
            let largeImage = cameraImage.withConfiguration(largeConfig)
            button.setImage(largeImage, for: .normal)
        }
        //        button.tintColor = UIColor(red: 96/255, green: 99/255, blue: 104/255, alpha: 1)
        button.tintColor = DesignSystemColor.Purple.value
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let weatherImage : UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.text = Date().koreanDateString()
        label.font = DesignSystemFont.Pretendard_Bold18.value
        return label
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
    
    private lazy var keyboardToolBar: UIToolbar = {
        let toolbar = UIToolbar()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneBtnClicked))
        toolbar.items = [flexBarButton, doneBarButton]
        toolbar.sizeToFit()
        return toolbar
    }()
    
    private func setImageToCameraButton(image: UIImage?) {
        guard let image else { return }
        self.pickedImage = image
        cameraButton.backgroundColor = .clear
        cameraButton.setImage(nil, for: .normal)
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 75
        cameraButton.setBackgroundImage(image, for: .normal)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetUI()
        SetMap()
        setUpKeyboard()
    }
    
    init(pinMode: PinMode) {
        super.init(nibName: nil, bundle: nil)
        
        switch pinMode {
        case let .create(latitude, longitude):
            
            self.pinEntity = PinEntity(
                pin_id: UUID(),
                title: "",
                latitude: latitude, longitude: longitude,
                address: "",
                date: Date(),
                weather: "",
                description: "",
                mediaPath: nil
            )
            service.fetchCurrentWeather(latitude: latitude, longitude: longitude) { items in
                guard let items = items else { return }
                let icon = items.weather[0].icon
                self.weatherImage.image = UIImage(named: icon)
                self.pinEntity.weather = icon
            }
        case let .edit(PinEntity):
            self.pinEntity = PinEntity
            dateLabel.text = pinEntity.date.koreanDateString()
            titleTextField.text = pinEntity.title
            contentTextView.text = pinEntity.description
            self.setImageToCameraButton(image: pinEntity.mediaPath)
        }
        
        
        let map = MKMapView()
        let lat = pinEntity.latitude
        let long = pinEntity.longitude
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long) // San Francisco, CA
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        map.layer.cornerRadius = 10
        map.layer.borderColor = DesignSystemColor.Lavender10.value.cgColor
        map.layer.borderWidth = 2
        
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long) // San Francisco, CA
        map.addAnnotation(annotation)
        map.showsUserLocation = false
        map.isUserInteractionEnabled = false
        
        mapView = map
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUI
    private func SetUI() {
        titleTextField.inputAccessoryView = keyboardToolBar
        contentTextView.inputAccessoryView = keyboardToolBar
        contentTextView.delegate = self
        titleTextField.delegate = self
        
        closeButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        self.view.addSubviews(mapView, saveButton, contentTextView, titleTextField, cameraButton, weatherImage, dateLabel, closeButton)
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(3)
            $0.height.equalToSuperview().multipliedBy(0.25)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(40)
        }
        
        weatherImage.snp.makeConstraints{
            $0.top.equalTo(mapView.snp.bottom).offset(10)
            //            $0.leading.equalTo(view.snp.centerX).offset(100)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(35)
        }
        
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(mapView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(180)
            $0.height.equalTo(30)
        }
        
        
        
        cameraButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        
        titleTextField.snp.makeConstraints{
            $0.top.equalTo(cameraButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(saveButton.snp.top).offset(-30)
        }
        
        saveButton.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(60)
            $0.height.equalTo(55)
        }
        
        
    }
    
    private func SetMap(){
        mapView = MKMapView(frame: self.view.bounds)
        mapView = MKMapView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height / 4))
    }
    
    //MARK: 저장버튼 눌림
    @objc private func saveButtonTapped() {
        guard let text = titleTextField.text, !text.isEmpty else {
            self.showToast(message: "제목을 입력해주세요.")
            return
        }
        
        pinEntity.title = titleTextField.text ?? ""
        pinEntity.description = contentTextView.text ?? ""
        pinEntity.mediaPath = pickedImage
        
        isAdded?(pinEntity)
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            self.view.frame.origin.y = -keyboardHeight
        }
    }
    
    //MARK: 키보드가 사라질 때 동작
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

//MARK: - PinEditViewController 내에서 사진 선택 기능을 쉽게 사용
extension PinEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            setImageToCameraButton(image: selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PinEditViewController: UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "제목을 작성해주세요." {
            textField.text = ""
        }
        textField.layer.borderColor = DesignSystemColor.Purple.value.cgColor
        textField.layer.borderWidth = 2.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = DesignSystemColor.Lavender10.value.cgColor
        textField.layer.borderWidth = 2.0
    }
    
    
    //MARK: 사용자가 텍스트뷰에 입력을 시작할 때 기본 안내 문구
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "남기고자 하는 메모가 있다면 작성해주세요." {
            textView.text = ""
            textView.textColor = .black
        }
        textView.layer.borderColor = DesignSystemColor.Purple.value.cgColor
        textView.layer.borderWidth = 2.0
    }
    
    // MARK: 텍스트뷰가 비어있을 때 안내 메시지를 다시 표시
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "남기고자 하는 메모가 있다면 작성해주세요."
            textView.textColor = .lightGray
        }
        
        DispatchQueue.main.async {
            textView.layer.borderColor = DesignSystemColor.Lavender10.value.cgColor
            textView.layer.borderWidth = 2.0
        }
    }
}

#Preview{
    
    PinEditViewController(pinMode: .create(latitude: 128.125312, longitude: 37.4864321))
    
}
