
typealias FBEvent = [String: String]
typealias FIREvent = [String: String]
typealias FunnelEvent = [String: String]

enum Event {
    case facebook(FBEvent)
    case firebase(FIREvent)
    case funnel(FunnelEvent)
}

protocol AnalyticProvider {
    func logEvent(_ event: Event)
}

// Фасад
struct AnalyticsFacade {
    private let _providers: [AnalyticProvider]

    init(providers: AnalyticProvider...) {
        _providers = providers
    }
}

extension AnalyticsFacade: AnalyticProvider {
    func logEvent(_ event: Event) {
        _providers.forEach { $0.logEvent(event) }
    }
}

// Конкретные реализации
struct FIRAnalytics {
    func logEvent(_ event: FIREvent) {}
}
extension FIRAnalytics: AnalyticProvider {
    func logEvent(_ event: Event) {
        guard let firEvent = event.firebase else {
            return
        }
        logEvent(firEvent)
    }
}

// Используем фабрику
enum AnalyticsFactory {
    static func createAnalyticProvider() -> AnalyticProvider {
        let firAnalytics: AnalyticProvider = FIRAnalytics()
        return AnalyticsFacade(providers: firAnalytics)
    }
}

let analytics = AnalyticsFactory.createAnalyticProvider()
analytics.logEvent(.facebook(FBEvent()))

// Один ивент в набор аналитик
extension Event {
    var facebook: FBEvent? {
        switch self {
        case .firebase(let firEvent):
            return firEvent
        case .funnel(let funnelEvent):
            return funnelEvent.asFacebook
        default:
            return nil
        }
    }

    var firebase: FIREvent? {
        switch self {
        case .firebase(let firEvent):
            return firEvent
        case .funnel(let funnelEvent):
            return funnelEvent.asFirebase
        default:
            return nil
        }
    }
}

// Mapping
extension FunnelEvent {
    var asFirebase: FIREvent {
        self as! FIREvent
    }

    var asFacebook: FBEvent {
        self as! FBEvent
    }
}

// Для двух аналитик в именах событий заменить . на _

