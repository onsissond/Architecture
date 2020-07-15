public enum AnalyticsFactory {
    public static func createAnalyticProvider() -> LogEvent {
        AppAnalyticProvider.make(
            providers: AnalyticsFactory.firebase
        )
    }
}

private extension AnalyticsFactory {
    static var firebase: LogEvent {
        FirebaseAnalyticProvider.make(
            logEvent: { print($0) }
        )
    }

    static var funnel: LogEvent {
        FunnelAnalyticProvider.make(
            logEvent: { print($0) }
        )
    }
}
