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
            XCTAssertEqual(responseError, QueryError.invalidReponame, "When an empty reponame is provided, responseError should be equal to QueryError.invalidReponame but it is not")
            XCTAssertNotNil(responseError, "When empty reponame string is provided, should return error but it is not returning error")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchRepoCommitsWebservice_WhenEmptyUsernameProvided_ShouldReturnError() {
        // Arrange
        let expectation = self.expectation(description: "A username string expectation")
        // Act
        sut.fetchRepoCommits(username: "", repoName: "9square") { responseError, responseData in
            // Assert
            XCTAssertEqual(responseError, QueryError.invalidUsername, "When an empty username is provided, responseError should be equal to QueryError.invalidUsername but it is not")
            XCTAssertNotNil(responseError, "When an empty username is provided, responseError should not be nil but it is nil")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchUserReposWebservice_WhenDidReceivedDifferentJSONResponse_ErrorTookPlace() {
        let jsonString = "{\"path\":\"/users\", \"error\":\"Internal Server Error\"}"
        let jsonData = jsonString.data(using: .utf8)
        MockURLProtocol.stubResponse = jsonData
        let expectation = self.expectation(description: "fetchUserRepos() method expectation for a response that contains a different JSON structure")
        sut.shouldReturnError = true
        sut.responseErrorType = .jsonParse
        // Act
        sut.fetchRepoCommits(username: "Donkemezuo", repoName: "Githubmobile") { responseError, responseData in
            // Assert
            XCTAssertNil(responseData, "Expect responseData to be NIL but it is returning a value")
            XCTAssertEqual(responseError, QueryError.jsonParse, "fetchUserRepos() method did not return expected model parsing error")
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
