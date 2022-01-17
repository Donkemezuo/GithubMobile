//
//  FetchUserReposWebserviceTest.swift
//  GithubMobileTests
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import XCTest
@testable import GithubMobile

class FetchUserReposWebserviceTest: XCTestCase {
    var sut: Webservice!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        sut = Webservice(urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        MockURLProtocol.stubResponse = nil
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchUserReposWebservice_WhenEmptyUsernameProvided_ShouldReturnError() {
        // Arrange
        let expectation = self.expectation(description: "An username string expectation ")
        // Act
        sut.fetchUserRepos(username: "") { responseError, responseData in
            XCTAssertEqual(responseError, QueryErrors.invalidURL(urlString: ""))
            XCTAssertNil(responseError, "When empty username is provided, responseError should return NILL but it is not returning NILL")
            expectation.fulfill()
        }
        // Assert
        self.wait(for: [expectation], timeout: 2)
    }
    
    
    
}
