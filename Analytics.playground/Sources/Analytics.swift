public typealias LogEvent = (Event) -> Void

public enum AppAnalyticProvider {
    public static func make(
        providers: LogEvent...
    ) -> LogEvent {
        return { event in
            providers.forEach { $0(event) }
        }
    }
}
