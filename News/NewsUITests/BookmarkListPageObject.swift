//
//  BookmarkListPageObject.swift
//  NewsUITests
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import XCTest

@discardableResult
func bookmarkListScreen(app: XCUIApplication = .init(), closure: (BookmarkListPageObject) -> Void = { _ in }) -> BookmarkListPageObject {
    let robot = BookmarkListPageObject(app: app)
    closure(robot)
    return robot
}

public class BookmarkListPageObject {
    let app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
    }

    @discardableResult
    func headlines(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
        with(app.buttons["headlines"], closure)
    }

    @discardableResult
    func sources(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
        with(app.buttons["sources"], closure)
    }

    @discardableResult
    func cell(index: UInt, _ closure: (Cell) -> Void = {_ in }) -> Cell {
        with(Cell(element: app.collectionViews["bookmark"].cells.element(boundBy: Int(index))), closure)
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
