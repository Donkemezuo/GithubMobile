//
//  FetchRepoCommitsWebserviceTest.swift
//  GithubMobileTests
//
//  Created by Raymond Donkemezuo on 1/18/22.
//

import XCTest
@testable import GithubMobile

class FetchRepoCommitsWebserviceTest: XCTestCase {
    var sut: MockWebservice!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        sut = MockWebservice(urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        MockURLProtocol.stubResponse = nil
    }
    
    func testFetchRepoCommitsWebservice_WhenEmptyReponameProvided_ShouldReturnError() {
        // Arrange
        let expectation = self.expectation(description: "A repo name string expectation")
        
        // Act
        sut.fetchRepoCommits(username: "Donkemezuo", repoName: "") { responseError, responseData in
            // Assert
            XCTAssertEqual(responseError, QueryErrors.invalidReponame)
            XCTAssertNotNil(responseError, "When empty reponame string is provided, should return error but it is not returning error")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 2)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
