//
//  SourcesPageObject.swift
//  NewsUITests
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import XCTest

@discardableResult
func sourcesScreen(app: XCUIApplication = .init(), closure: (SourcesPageObject) -> Void = { _ in }) -> SourcesPageObject {
    let robot = SourcesPageObject(app: app)
    closure(robot)
    return robot
}

public class SourcesPageObject {
    let app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
    }

    @discardableResult
    func headlines(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
        with(app.buttons["headlines"], closure)
    }

    @discardableResult
    func bookmarks(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
        with(app.buttons["bookmarks"], closure)
    }

    @discardableResult
    func cell(index: UInt, _ closure: (Cell) -> Void = {_ in }) -> Cell {
        with(Cell(element: app.collectionViews["sources"].cells.element(boundBy: Int(index))), closure)
    }

    struct Cell {
        let element: XCUIElement

        @discardableResult
        func name(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.staticTexts["name"], closure)
        }

        @discardableResult
        func desc(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.staticTexts["desc"], closure)
        }

        @discardableResult
        func category(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.buttons["category"], closure)
        }

        @discardableResult
        func language(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.staticTexts["language"], closure)
        }

        @discardableResult
        func country(_ closure: (XCUIElement) -> Void = {_ in }) -> XCUIElement {
            with(element.staticTexts["country"], closure)
        }
    }
}
