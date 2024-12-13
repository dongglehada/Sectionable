# Sectionable

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

`Sectionable` 프로토콜은 컬렉션 뷰에서 Compositional Layout을 편리하게 사용할 수 있도록 설계되었습니다. 이 프로토콜을 사용하면 제네릭 타입 CellType을 통해 유연하게 컬렉션 뷰 셀을 처리할 수 있습니다. Section과 Header, Footer를 각각 재사용 가능하도록 설계되었습니다.

### Sectionable 프로토콜 정의
```swift
protocol Sectionable {
    associatedtype CellType: UICollectionViewCell, Inputable
    var inputDataList: [CellType.Input] { get set }
    var supplementaryItems: [any SectionSupplementaryItemable]? { get set }
    
    func getSection(section: Int, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func setSection(section: Int, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func getCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func getSupplementaryItem(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
}
```

### SectionSupplementaryItemable 프로토콜
`SectionSupplementaryItemable` 프로토콜은 Supplementary View에 대한 인터페이스를 정의합니다. 이 프로토콜을 준수하는 타입은 Supplementary View를 설정하고 반환하는 기능을 가져야 합니다.

### SectionSupplementaryItemable 프로토콜 정의
```swift
protocol SectionSupplementaryItemable {
    associatedtype ReusableView: UICollectionReusableView, Inputable
    var widthDimension: NSCollectionLayoutDimension { get set }
    var heightDimension: NSCollectionLayoutDimension { get set }
    var elementKind: String { get set }
    var alignment: NSRectAlignment { get set }
    var reusableView: ReusableView { get set }
    var viewInput: ReusableView.Input { get set }
}
```

### SectionSupplementaryItemable 확장
```swift
extension SectionSupplementaryItemable {
    func getItem(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.register(ReusableView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reusableView.identifier)
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableView.identifier, for: indexPath) as? ReusableView else {
            return UICollectionReusableView()
        }
        view.injection(with: viewInput)
        return view
    }
}
```

### SectionDecorationItemable 프로토콜
`SectionDecorationItemable` 프로토콜은 컬렉션 뷰의 섹션에 장식 뷰(Decoration View)를 추가하기 위한 인터페이스를 정의합니다.

### SectionDecorationItemable 프로토콜 정의
```swift
protocol SectionDecorationItemable {
    associatedtype DecorationView: UICollectionReusableView, Inputable
    var backgroundColor: UIColor { get set }
    var layoutSize: NSCollectionLayoutSize { get set }
    var elementKind: String { get set }
    var decorationView: DecorationView { get set }
    var viewInput: DecorationView.Input { get set }
}
```
---

## ✨ 주요 기능
- Compositional Layout을 간단하게 생성할 수 있습니다.
- 코드 가독성과 유지보수성을 향상시킵니다.
- 다양한 레이아웃 요구사항에 쉽게 커스터마이징 가능합니다.

---

## 📦 설치 방법

### Swift Package Manager (SPM)
프로젝트에 이 패키지를 추가하려면 `Package.swift` 파일에 다음을 추가하세요:

```swift
dependencies: [
    .package(url: "https://github.com/dongglehada/Sectionable.git", from: "1.0.0")
]
```

그런 다음 필요한 곳에서 패키지를 import 하세요:

```swift
import Sectionable
```

---

## 🏁 사용 하기

### 1. 셀 생성
- Section에서 사용할 셀을 생성합니다. 이 셀은 `Inputable` 프로토콜을 채택해야 합니다.
```swift
class MainBannerCell: UICollectionViewCell {
    ...
}

extension MainBannerCell: Inputable {
    struct Input {
        var title: String
    }
    
    func injection(with: Input) {
        label.text = with.title
    }
}
```

### 2. Section 생성
- 섹션을 생성하고 `setSection` 메서드에서 레이아웃을 설정합니다.
```swift
struct MainBannerSection: Sectionable {
    var supplementaryItems: [any SectionSupplementaryItemable]?
    var inputDataList: [CellType.Input]
    
    typealias CellType = MainBannerCell
    
    func setSection(section: Int, env: any NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return section
    }
}
```

### 3. Controller에서 Section 설정
- 사용할 모든 섹션을 리턴할 수 있는 메서드 또는 프로퍼티를 준비합니다.
```swift
let firstSection = MainBannerSection(inputDataList: [
    .init(title: "Test"),
    .init(title: "Test"),
    .init(title: "Test"),
    .init(title: "Test"),
    .init(title: "Test"),
    .init(title: "Test"),
])

func getSectionData() -> [any Sectionable] {
    return [firstSection]
}
```

### 4. CollectionView 설정
- `UICollectionViewCompositionalLayout`을 사용하여 섹션을 리턴합니다.
```swift
lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: self.compositionalLayout)
    view.backgroundColor = .systemBackground
    return view
}()

lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
    UICollectionViewCompositionalLayout { [weak self] section, env in
        guard let self = self else {
            return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            ))
        }
        return self.getSectionData()[section].getSection(section: section, env: env)
    }
}()

// ViewDidLoad
collectionView.register(MainBannerCell.self, forCellWithReuseIdentifier: MainBannerCell.identifier)

// DataSource
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return getSectionData().count
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return getSectionData()[section].inputDataList.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return getSectionData()[indexPath.section].getCell(collectionView: collectionView, indexPath: indexPath)
}
```

---

## 📄 라이선스
이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

## 💬 연락하기
질문이나 피드백은 [ghddns34@gmail.com](mailto:ghddns34@gmail.com)으로 연락해주세요.
