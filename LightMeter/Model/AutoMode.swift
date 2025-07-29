//
//  AutoMode.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/28/25.
//

extension Models {
    enum AutoMode :Int, CaseIterable {
        /** 수동 */
        case manual = 0
        /** 조리개 우선 */
        case modeA = 1
        /** 셔터우 선 */
        case modeS = 2
        /** 멈춤 */
        case pause = 3
    }
}
