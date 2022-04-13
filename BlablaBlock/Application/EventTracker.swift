//
//  EventTracker.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/30.
//

import Firebase
import FirebaseAnalytics
import Mixpanel

public final class EventTracker {
    
    private static var mixpanel = Mixpanel.mainInstance()
    
    static func initialize() {
        Mixpanel.initialize(token: "90848c9a3b00a87eff0716385e4755a8")
        #if DEBUG
        mixpanel.optOutTracking()
        #else
        mixpanel.optInTracking()
        #endif
        FirebaseApp.configure()
    }
    
    static func setUser(id: String) {
        mixpanel.identify(distinctId: id)
        mixpanel.people.set(properties: [
            "user_name" : keychainUser[.userName],
            "user_email" : keychainUser[.userEmail]
        ])
        Analytics.setUserID(id)
    }
    
    private static let eventTrackingQueue = DispatchQueue(
        label: "com.wuchi.eventTrackingQueue",
        qos: .background,
        attributes: .concurrent
    )
    
    class Builder {
        
        private var properties: [String: Any] = [:]

        func setProperty(name: EventTracker.Property, value: Any) -> Builder {
            properties[name.rawValue] = value
            return self
        }
        
        func logEvent(_ name: EventTracker.Event) {
            let properties = self.properties
            eventTrackingQueue.async {
                var mixpanelProperties: [String: MixpanelType] = [:]
                properties.forEach {
                    mixpanelProperties[$0.key] = $0.value as? MixpanelType
                }
                EventTracker.mixpanel.track(
                    event: name.rawValue,
                    properties: properties.mapValues {
                        $0 as? MixpanelType
                    }
                )
            }
            eventTrackingQueue.async {
                Analytics.logEvent(name.rawValue, parameters: properties)
            }
        }
    }
}

public extension EventTracker {
    
    enum Event: String {
        // v1.0/34
        case REFRESH_HOME_PAGE = "refresh_HomePage"
        case REFRESH_EXPLORE_PAGE = "refresh_ExplorePage"
        case REFRESH_PERSONAL_PAGE_PORTFOLIO = "refresh_PersonalPage_Portfolio"
        case REFRESH_PERSONAL_PAGE_PERFORMANCE = "refresh_PersonalPage_Performance"
        case REFRESH_PERSONAL_PAGE_FOLLOWED_PORTFOLIO = "refresh_PersonalPage_FollowedPortfolio"
        case CHECK_PERSONAL_PAGE_TRADE_RECORD = "check_PersonalPage_TradeRecord"
        case CHECK_OTHERS_PROFILE = "check_OthersProfile"
        case CHECK_OTHERS_PROFILE_TRADE_RECORD = "check_OthersProfile_TradeRecord"
        
        // v1.0/36
        case CHECK_PERSONAL_PAGE_PERFORMANCE = "check_PersonalPage_Performance"
        case CHECK_PERSONAL_PAGE_FOLLOWED_PORTFOLIO = "check_PersonalPage_FollowedPortfolio"
        case CHECK_OTHERS_PROFILE_PERFORMANCE = "check_OthersProfile_Performance"
        case CHECK_OTHERS_PROFILE_FOLLOWED_PORTFOLIO = "check_OthersProfile_FollowedPortfolio"
        
        // v1.0/40
        case SIGN_UP = "signup"
    }
    
    enum Property: String {
        case USER_B = "userB"
    }
}
