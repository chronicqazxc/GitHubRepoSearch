//
//  StubURLSession.swift
//  GitHubRepoSearch
//
//  Created by YuHan Hsiao on 2021/07/08.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    private var completionHandler: DataTaskCompletionHandler
    private var stubbedData: Data?
    private var stubbedResponse: URLResponse?
    private var stubbedError: Error?
    
    init(stubbedData: Data?, stubbedResponse: URLResponse?, stubbedError: Error?,  completionHandler: @escaping DataTaskCompletionHandler) {
        self.stubbedData = stubbedData
        self.stubbedResponse = stubbedResponse
        self.stubbedError = stubbedError
        self.completionHandler = completionHandler
        super.init()
    }
    
    override func resume() {
        completionHandler(stubbedData, stubbedResponse, stubbedError)
    }
    
    override func cancel() {
        
    }
}

class StubURLSession: URLSessionProtocol {
    private var url: URL?
    private let stubbedData: Data?
    private let stubbedResponse: URLResponse?
    private let stubbedError: Error?

    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
      self.stubbedData = data
      self.stubbedResponse = response
      self.stubbedError = error
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        url = request.url
        return MockURLSessionDataTask(stubbedData: stubbedData, stubbedResponse: stubbedResponse, stubbedError: stubbedError, completionHandler: completionHandler)
    }
}
