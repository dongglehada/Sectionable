//
//  SectionDecorationItem.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 9/3/24.
//

import UIKit

/// `SectionDecorationItemable` 프로토콜은 데코레이션 뷰에 대한 인터페이스를 정의합니다.
/// 이 프로토콜을 준수하는 타입은 데코레이션 뷰를 설정하고 반환하는 기능을 가져야 합니다.
public protocol SectionDecorationItemable {
    
    /// 데코레이션 뷰의 타입을 정의합니다. 이 뷰는 `UICollectionReusableView`와 `Inputable` 프로토콜을 준수해야 합니다.
    associatedtype ReusableView: UICollectionReusableView & Inputable
    
    /// 데코레이션 뷰의 종류를 나타내는 문자열입니다.
    var elementKind: String { get set }
    
    /// 데코레이션 뷰의 인스턴스입니다.
    var reusableView: ReusableView { get set }
    
    /// 데코레이션 뷰에 주입될 데이터입니다.
    var viewInput: ReusableView.Input { get set }
}
