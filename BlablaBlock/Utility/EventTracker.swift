//
//  EventTracker.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/30.
//

import FirebaseAnalytics

public final class EventTracker {
    
    static func setUser(id: String) {
        Analytics.setUserID(id)
    }
    
    private static let eventTrackingQueue = DispatchQueue(
        label: "com.wuchi.eventTrackingQueue",
        qos: .background,
        attributes: .concurrent
    )
    
    class Builder {
        
        private var properties = [String : Any]()

        func setProperty(name: EventTracker.Property, value: Any) -> Builder {
            properties[name.rawValue] = value
            return self
        }
        
        func logEvent(_ name: EventTracker.Event) {
            let properties = self.properties
            eventTrackingQueue.async {  
                Analytics.logEvent(name.rawValue, parameters: properties)
            }
        }
    }
}

public extension EventTracker {
    
    enum Event: String {
        case REFRESH_HOME_PAGE = "refresh_HomePage"
        case REFRESH_EXPLORE_PAGE = "refresh_ExplorePage"
        case REFRESH_PERSONAL_PAGE_PORTFOLIO = "refresh_PersonalPage_Portfolio"
        case REFRESH_PERSONAL_PAGE_PERFORMANCE = "refresh_PersonalPage_Performance"
        case REFRESH_PERSONAL_PAGE_FOLLOWED_PORTFOLIO = "refresh_PersonalPage_FollowedPortfolio"
        case CHECK_PERSONAL_PAGE_TRADE_RECORD = "check_PersonalPage_TradeRecord"
        case CHECK_OTHERS_PROFILE = "check_OthersProfile"
        case CHECK_OTHERS_PROFILE_TRADE_RECORD = "check_OthersProfile_TradeRecord"
    }
    
    enum Property: String {
        case USER_B = "userB"
    }
}
