//
//  NewsUITestsLaunchTests.swift
//  NewsUITests
//
//  Created by Mateusz Mackowiak on 30/04/2023.
//

import XCTest

@discardableResult
func topHeadlinesScreen(app: XCUIApplication = .init(), closure: (TopHeadlinesPageObject) -> Void = { _ in }) -> TopHeadlinesPageObject {
    let robot = TopHeadlinesPageObject(app: app)
    closure(robot)
    return robot
}

public class TopHeadlinesPageObject {
    let app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
    }

    @discardableResult
    func cell(index: UInt, _ closure: (Cell) -> Void = {_ in }) -> Cell {
        with(Cell(element: app.collectionViews["articles"].cells.element(boundBy: Int(index))), closure)
    }

    @discardableResult
    func bookmarks(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
        with(app.buttons["bookmarks"], closure)
    }

    @discardableResult
    func sources(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
        with(app.buttons["sources"], closure)
    }

    struct Cell {
        let element: XCUIElement

        @discardableResult
        func title(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.staticTexts["title"], closure)
        }

        @discardableResult
        func desc(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.staticTexts["desc"], closure)
        }

        @discardableResult
        func bookmark(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.buttons["bookmark"], closure)
        }

        @discardableResult
        func source(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.staticTexts["source"], closure)
        }

        @discardableResult
        func creationDate(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.staticTexts["creationDate"], closure)
        }
    }
}

@discardableResult
func with<T>(_ element: @autoclosure () -> T, _ closure: (T) throws -> Void = { _ in }) rethrows -> T {
    let xcElement = element()
    try closure(xcElement)
    return xcElement
}
