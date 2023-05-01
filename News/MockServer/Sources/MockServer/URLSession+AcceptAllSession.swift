import Foundation

extension URLSession {
    public static var ephemeralSSLAcceptLocalhost: URLSession {
        URLSession(configuration: .ephemeral, delegate: AcceptURLSessionDelegate(), delegateQueue: nil)
    }
}

class AcceptURLSessionDelegate: NSObject, URLSessionDelegate {
    public func urlSession(_ session: URLSession,
         didReceive challenge: URLAuthenticationChallenge,
            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            // Inform the user that the user name and password are incorrect
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
           && challenge.protectionSpace.serverTrust != nil
           && challenge.protectionSpace.host == "localhost" {

            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
}
