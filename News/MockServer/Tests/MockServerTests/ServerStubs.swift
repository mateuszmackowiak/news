import Foundation
import MockServer

extension ServerStub {
    public static func homeLocationGetStub(_ location: @autoclosure @escaping () -> Location = .random()) -> ServerStub {
        HomeLocationServerStub(location)
    }
}

public struct Location {
    let latitude: Double
    let longitude: Double

    public static func random() -> Location {
        Location(latitude: .random(in: -90...90), longitude: .random(in: -180...180))
    }
}

public class HomeLocationServerStub: ServerStub {
    public init(_ locationProvider: @escaping () -> Location) {
        super.init(matchingRequest: {
            $0.method == .GET && $0.uri == "/user-account-api/v1/me/home-location"
        }) { _ in
            let location = locationProvider()
            return .success(responseBody: Data("""
            {
              "location": {
                "coordinates": [\(location.latitude), \(location.longitude)],
                "type": "Point"
              }
            }
            """.utf8))
        }
    }
}
