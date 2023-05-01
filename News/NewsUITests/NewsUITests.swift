//
//  NewsUITests.swift
//  NewsUITests
//
//  Created by Mateusz Mackowiak on 30/04/2023.
//

import XCTest

final class NewsUITests: XCTestCase {
    private var app: XCUIApplication!

    private lazy var server: Server! = Server(port: 7564, stubs: [ServerStub.articles()], unhandledBlock: {
        XCTFail("Unhandled request \($0)")
    })

    override func setUpWithError() throws {
        try super.setUpWithError()
        try server.start()
        app = XCUIApplication()
        app.launchArguments = ["-LaunchArgumentUseLocalServer", "\(server.port)"]
        app.launch()
    }

    override func tearDownWithError() throws {
        try server.stop()
        server = nil
        app.terminate()
        app = nil
        try super.tearDownWithError()
    }

    func testTopHeadlinesScreen() {
        topHeadlinesScreen(app: app).cell(index: 0) {
            XCTAssertTrue($0.element.waitForExistence(timeout: 20))
            XCTAssertEqual($0.title().label, "The entire Super Mario Bros. movie keeps getting posted to Twitter - The Verge")
            XCTAssertEqual($0.desc().label, "Twitter doesn’t have a moderation team anymore, so entire movies are getting posted to the platform and staying up for days.")
            XCTAssertEqual($0.source().label, "The Verge")
        }
    }
}
