public enum AnalyticsFactory {
    public static func createAnalyticProvider() -> AnalyticProvider {
        AnalyticsFacade(providers: FirebaseAnalyticProvider())
    }
}
