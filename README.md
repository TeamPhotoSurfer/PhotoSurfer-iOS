# PhotoSurfer-iOS
아무래도 여름엔 서핑 ^^ 🌊🏄🏻‍♂️

<img width="704" alt="image" src="https://user-images.githubusercontent.com/68391767/178255299-d05bbc93-648e-4fb1-8da3-790e1d4eeb86.png">

# Photo Surfer

<img width="139" alt="image" src="https://user-images.githubusercontent.com/68391767/178255278-4fe173a7-50b8-4a0f-9797-2d22af65677a.png">

- 태그와 알림을 통해 원하는 사진을 빠르게 찾는, 효율의 아카이빙 공간 **Photo Surfer**

---

## ****Contributors****

|<img width="205" alt="image" src="https://user-images.githubusercontent.com/68391767/178255375-e15e8358-57f8-454d-978f-fee9f72f6f7d.png">|<img width="244" alt="image" src="https://user-images.githubusercontent.com/68391767/178255408-09483988-e4ee-4513-ba2c-960ba207d8d3.png">|<img width="269" alt="image" src="https://user-images.githubusercontent.com/68391767/178255435-44748b61-3b8b-475d-b5ce-2188794c7ac9.png">|
|:--:|:--:|:--:|
|김하늘|김혜수|양정연|
|바지사장 성장형 개발자☁️|완성형 초고수 개발자✨|풀스택 레전드 열정킹 개발자👑|
|@haneulKimaa|@hyesuuou|@jeongkite|

## ****Project Setting****

### 🏄‍♂️ ****Development Environment****

| Environment | Tool | Tag | Based on |
| --- | --- | --- | --- |
| Framework | UIKit | Layout |  |
| Library | Moya | Network | 직접적인 네트워킹을 수행하지 않아 안전함 |
|  | IQKeyboardManager | Keyboard | 여러 뷰에서 Keyboard 구현 시 편의를 위함 |
|  | Kingfisher | Image Caching | 편리하고 빠른 이미지 캐싱 처리 |
|  | Lottie | Animation | Splash에 사용될 애니메이션 처리 편의를 위함 |
|  | SwiftLint | Swift Style | 클린 코드 습관을 기르기 위함 |

### 🏄‍♂️  ****Convention****

[Code convention](https://go-photosurfer.notion.site/Code-Convention-55157972d552415f9187d270ffdc4e40)

[Commit convention](https://go-photosurfer.notion.site/Commit-Convention-b48d41ce3ddb40d4b88d258de18fac8f)

## 🏄‍♂️ ****Git Flow****

```
1. Issue를 생성한다. // 작업의 단위, 번호 부여

2. Issue의 Feature Branch를 생성한다. // ex. feat/#이슈번호-hs

3. ~작업~ // Add - Commit - Push - Pull Request 의 과정

4. Pull Request가 작성되면 작성자 이외의 다른 팀원이 Code Review를 한다.

5. Code Review가 완료되고, 
	 2명 이상 Approve 하면 Pull Request 작성자가 develop Branch로 merge 한다.
	 // Conflicts 방지

6. 팀원들에게 merge 사실을 알린다.
  
7. 브랜치를 삭제한다.

8. 다른 팀원들은 merge된 작업물을 pull하고 다시 각자 맡은 작업을 이어나간다.
```

## 🏄‍♂️ Branch Naming

- `develop (default)`: 합치는 공간
- `feat/#이슈번호-기능설명-이름` : 기능을 개발하는 브랜치
    - 이슈별•작업별로 브랜치를 생성하여 기능을 개발함.
    - ex) feat/#32-homeUI-jy
- `fix/#이슈번호-기능설명-이름` : 버그를 수정하는 브랜치
- `main` : 개발이 완료된 산출물이 저장될 공간

## 🏄‍♂️ ****Folder Structure****

```
├── Info.plist
├── Resource
│   ├── Assets
│   │   └── AppIcon.xcassets
│   ├── Colors
│   │      └── Colors.xcassets
│   ├── Images
│   ├── Gifs // Lottie json파일
│   ├── Fonts
│   └── Storyboards // LaunchScreen
├── Source
│   ├── Application
│   │   └── AppDelegate
│   │   └── SceneDelegate
│   ├── Common
│   │   └── Consts
│   │   └── Extensions
│   │   └── Protocols
│   ├── Presentation
│   │   └── Common
│   │ 			└── Button // ex) PhotoSurferSearchButton.swift
│   │ 			└── TextField
│   │   └── Home// 뷰 별로 나누기
│   │       └── Views // ex) Home.storyboard
│   │             └── Cells // ex) HomeTableViewCell.swift, 
│   │															 HomeTableViewCell.xib
│   │       └── Controllers // ex) HomeViewController.swift, HomeViewController+Extension.swift
│   │   
│   ├── Service
│   │   └── Data
│   │        └── Model
│   │   └── Network
│   │        └── DTO // API별
└───
```
