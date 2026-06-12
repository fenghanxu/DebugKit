//
//  Documentation.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/12.

/// 说明文档

/*
 下面的方法用在搜索出关键词，加入显示json一大串时，不完整显示json，只是显示关键词的一部分，上下内容显示...
 
 例如：搜索  "poiCount":6
 
 ...
 "message":"成功",
 "poiCount":6,
 "poiList":[
 ...
 
 方法使用在
 cell.contentLabel.attributedText = highlightText(text: snippet(text: data[indexPath.row].message, keyword: searchTerm), keyword: searchTerm)
 
 */

/// 只显示部分关键内容
//func snippet(
//    text: String,
//    keyword: String
//) -> String {
//
//    guard let range = text.range(
//        of: keyword,
//        options: .caseInsensitive
//    ) else {
//        return text
//    }
//
//    let location =
//        text.distance(
//            from: text.startIndex,
//            to: range.lowerBound
//        )
//
//    let start = max(0, location - 30)
//    let end = min(
//        text.count,
//        location + keyword.count + 30
//    )
//
//    let startIndex =
//        text.index(
//            text.startIndex,
//            offsetBy: start
//        )
//
//    let endIndex =
//        text.index(
//            text.startIndex,
//            offsetBy: end
//        )
//
//    return "..." +
//    String(text[startIndex..<endIndex]) +
//    "..."
//}






