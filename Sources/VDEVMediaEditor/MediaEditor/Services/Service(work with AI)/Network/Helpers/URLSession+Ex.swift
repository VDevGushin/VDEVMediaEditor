//
//  URLSession+Ex.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation
import Combine

extension URLSession {
    func fetch<Response: Decodable>(for request: URLRequest,
                                    decoder: JSONDecoder,
                                    with type: Response.Type) async throws -> Response {
        log(request: request)
        let (data, httpResponse) = try await data(for: request)
        
        log(response: httpResponse as? HTTPURLResponse, data: data, error: nil)
        
        guard let httpResponse = httpResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        let statusCode = httpResponse.statusCode

        if (200...299).contains(statusCode) {
            return try decoder.decode(Response.self, from: data)
        }

        if statusCode == 401 {
            throw URLError(.userAuthenticationRequired)
        }

        throw URLError(.badServerResponse)
    }
    
    func fetch<Response: Decodable>(for request: URLRequest,
                                    decoder: JSONDecoder,
                                    with type: Response.Type) -> AnyPublisher<Response, Error> {


        log(request: request)

        return dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                
                log(response: element.response as? HTTPURLResponse, data: element.data, error: nil)

                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                let statusCode = httpResponse.statusCode

                if (200...299).contains(statusCode) {
                    return element.data
                }

                if statusCode == 401 {
                    throw URLError(.userAuthenticationRequired)
                }

                throw URLError(.badServerResponse)
            }
            .decode(type: Response.self, decoder: decoder)
            .eraseToAnyPublisher()


        //        dataTaskPublisher(for: request)
        //            .map(\.data)
        //            .decode(type: Response.self, decoder: decoder)
        //            .eraseToAnyPublisher()
    }
}

fileprivate extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}

fileprivate func log(request: URLRequest) {
    Log.d("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
    defer { Log.d("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
    let urlAsString = request.url?.absoluteString ?? ""
    let urlComponents = URLComponents(string: urlAsString)
    let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
    let path = "\(urlComponents?.path ?? "")"
    let query = "\(urlComponents?.query ?? "")"
    let host = "\(urlComponents?.host ?? "")"
    var output = """
   \(urlAsString) \n\n
   \(method) \(path)?\(query) HTTP/1.1 \n
   HOST: \(host)\n
   """
    for (key,value) in request.allHTTPHeaderFields ?? [:] {
        output += "\(key): \(value) \n"
    }
    if let body = request.httpBody {
        output += "\n \(String(data: body, encoding: .utf8) ?? "")"
    }
    Log.d(output)
}

fileprivate func log(response: HTTPURLResponse?, data: Data?, error: Error?) {

    Log.d("\n - - - - - - - - - - INCOMMING - - - - - - - - - - \n")
    defer { Log.d("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
    let urlString = response?.url?.absoluteString
    let components = NSURLComponents(string: urlString ?? "")
    let path = "\(components?.path ?? "")"
    let query = "\(components?.query ?? "")"
    var output = ""
    if let urlString = urlString {
        output += "\(urlString)"
        output += "\n\n"
    }
    if let statusCode =  response?.statusCode {
        output += "HTTP \(statusCode) \(path)?\(query)\n"
    }
    if let host = components?.host {
        output += "Host: \(host)\n"
    }
    for (key, value) in response?.allHeaderFields ?? [:] {
        output += "\(key): \(value)\n"
    }
    if let body = data {
        output += "\n\(String(data: body, encoding: .utf8) ?? "")\n"
    }
    if error != nil {
        output += "\nError: \(error!.localizedDescription)\n"
    }
    Log.d(output)
}
