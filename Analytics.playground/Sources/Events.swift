public typealias FBEvent = [String: String]
public typealias FIREvent = [String: String]
public typealias FunnelEvent = [String: String]

public enum Event {
    case facebook(FBEvent)
    case firebase(FIREvent)
    case funnel(FunnelEvent)
}

