//
//  FetchUserReposWebserviceTest.swift
//  GithubMobileTests
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import XCTest
@testable import GithubMobile

class FetchUserReposWebserviceTest: XCTestCase {
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
            // Assert
            XCTAssertEqual(responseError, QueryError.invalidUsername)
            XCTAssertNotNil(responseError, "When empty username string is provided, should return error but it is not returning Error")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchUserReposWebservice_WhenValidUsernameProvided_ShouldReturnSuccess() {
        // Arrange
        var jsonArr = [[String:Any]]()
        var jsonDict = [String:Any]()
        jsonDict["name"] = "9square"
        jsonArr.append(jsonDict)
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonArr, options: .prettyPrinted)
        MockURLProtocol.stubResponse = jsonData
        let expectation = self.expectation(description: "When a valid username is provided, should return data but it is not returning data")
        // Act
        sut.fetchUserRepos(username: "Donkemezuo") { responseError, responseData in
            // Assert
            XCTAssertNil(responseError)
            XCTAssertGreaterThan(responseData?.userRepos.count ?? 0, 0)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchUserReposWebservice_WhenDidReceivedDifferentJSONResponse_ErrorTookPlace() {
        // Arrange
        let jsonString = "{\"path\":\"/users\", \"error\":\"Internal Server Error\"}"
        let jsonData = jsonString.data(using: .utf8)
        MockURLProtocol.stubResponse = jsonData
        let expectation = self.expectation(description: "fetchUserRepos() method expectation for a response that contains a different JSON structure")
        // Act
        sut.fetchUserRepos(username: "Donkemezuo") { responseError, responseData in
            // Assert
            XCTAssertNil(responseData, "Expect responseData to be NIL but it is returning a value")
            XCTAssertEqual(responseError, QueryError.jsonParse, "fetchUserRepos() method did not return expected model parsing error")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 2)
    }
}
