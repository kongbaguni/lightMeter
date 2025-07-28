//
//  AutoMode.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/28/25.
//

extension Models {
    enum AutoMode :Int, CaseIterable {
        /** 조리개 우선 */
        case modeA = 0
        /** 셔터우 선 */
        case modeS = 1
        /** 수동*/
        case manual = 2
    }
}
