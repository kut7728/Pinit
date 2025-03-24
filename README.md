
<img src="" width="1920">

***

<div align="center" style="color: gray;">
  <i>이스트소프트 iOS 부트캠프 </i> <br>
  <i>2025.03.10 ~ 2025.03.25</i> <br>
</div>

<br/>

<h2 align="center">
  <br>
  ⭐️ 프로젝트 소개 ⭐
  <br>
</h2>

<div align="center" style="color: gray;">
  일상의 장소와 기억을 지도 위에 ‘핀’으로 남기는 <b>위치 기반 기록 앱</b><br/><b>PinIt</b>
</div>

<br/>

## [Team] 2안 김이한

| 김의택 | 안정흠 | 안세훈 | 한인탁 | 이규현 |
|:-:|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/77233954?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/21167914?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/78650062?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/197554863?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/144425677?v=4" width=100>|
|[@kut7728](https://github.com/kut7728)|[@JustHm](https://github.com/JustHm)|[@HISEHOONAN](https://github.com/HISEHOONAN)|[@IntakHan304](https://github.com/IntakHan304)|[@lkhwan0204](https://github.com/lkhwan0204)|

<br/>

## 🗺️ 주요 기능
### 🏃‍♂️ 위치기반 기록
(홈화면, 기록작성뷰 화면 사진) 설명으로 위치기반으로 기록된다는 점과 실시간 날씨가 같이 저장된다는 점 어필

### 📸 기록 조회
(과거기록뷰 사진) 달력으로 날짜를 선택해서 해당 날짜의 기록을 조회할수 있다는 점 어필

### 📝 리뷰 작성
(기록 상세뷰 사진) 상세뷰에서 각 기록에대한 리뷰를 남길 수 있다는 점 어필

<br/>

## 🧰 사용 기술 및 라이브러리

<table>
  <tr>
    <td><strong>🍎 UIKit</strong></td>
    <td>
      UI 컴포넌트로 화면 UI 구성, Codebase 형식으로 AutoLayout 설정</br>
      MVC 디자인 패턴 적용
    </td>
  </tr>
  <tr>
    <td><strong>🍎 CoreData</strong></td>
    <td> 사용자 데이터 CRUD를 위한 로컬DB </td>
  </tr>
  <tr>
    <td><strong>🍎 FileManager</strong></td>
    <td> 사용자 이미지 데이터 CRUD를 위한 스토리지 </td>
  </tr>
  <tr>
    <td><strong>🍎 MapKit</strong></td>
    <td> 
      사용자 위치 및 사용자 데이터를 보여주는 마커 MapView 사용</br>
      마커 클러스터 기능 사용
    </td>
  </tr>
  <tr>
    <td><strong>🍎 XCTest - UnitTest</strong></td>
    <td> 
      CoreData,FileManager CRUD 테스트</br>
      Moya RESTAPI fetch 테스트
    </td>
  </tr>
  <tr>
    <td><strong>🍎 CoreLocation</strong></td>
    <td> 
      사용자 위치 권한 요청</br>
      사용자 위치 실시간 업데이트
    </td>
  </tr>
</table>

<br>

<table>
  <tr>
    <td><strong>📦 SnapKit</strong></td>
    <td>Codebase 형식으로 간편하게 AutoLayout 구현</td>
  </tr>
  <tr>
    <td><strong>📦 FSCalender</strong></td>
    <td>간편하게 달력 뷰를 구현하고 데이터 핸들링</td>
  </tr>
  <tr>
    <td><strong>📦 Moya</strong></td>
    <td>RESTAPI 사용을 위한 라이브러리</td>
  </tr>
</table>
</br>

## 🚀 기술적 도전기

### 🍎 iOS
| 키워드 | 제목 |
| :-: | :- |
| CollectionView, Adapter패턴 | [📦 공통된 CollectionView 재사용을 위한 Adpater 패턴 적용기](https://github.com/kut7728/Pinit/wiki/📦-공통된-CollectionView-재사용을-위한-Adpater-패턴-적용기) |
| MapKit Marker Cluster | [🌐 MapKit의 마커에 클러스터를 사용해보자!](https://github.com/kut7728/Pinit/wiki/🌐-MapKit의-마커에-클러스터를-사용해보자!) |
| Unit Test | [🎫 CoreData, FileManager CRUD 테스트 작성해보기](https://github.com/kut7728/Pinit/wiki/🎫-CoreData,-FileManager-CRUD-테스트-작성해보기) |



## 📔 문서

| 팀 페이지 | 기획/디자인 | 템플릿 | 회의록 | 기능명세서 | 
| :-: | :-: | :-: | :-: | :-: |
| 📚 [노션](https://kut7728.notion.site/team2-projectsite?pvs=4) | 🎨 [기획/디자인](https://www.figma.com/design/iR7lbwFWqPsbkpElXBVEl3/PinIt?node-id=0-1&t=4bTVEqEFuJVSoaZt-1)| 📃 [템플릿](https://github.com/kut7728/Pinit/wiki/템플릿)| 📝 [회의록](https://www.notion.so/kut7728/1b4a988b89d780fd8467d5d5e8275256?v=1b4a988b89d7803480e5000ce2d0b58f&pvs=4) | 📝 [기능명세서](https://docs.google.com/spreadsheets/d/1YNMxF1E2F_T6BspqpI4CF22eKbS_wbcuXSFk1wTMLlw/edit?usp=sharing)
