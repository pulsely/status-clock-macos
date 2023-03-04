//
//  TimeCalculator.swift
//  StatusClock
//
//  Created by Pulsely on 3/4/23.
//

import Foundation
import SwiftUI


class TimeCalculator: ObservableObject {
    @AppStorage(DEFAULTS_SHOW_HIDE_SECONDS)  var show_seconds = true
    @AppStorage(DEFAULTS_TIME_ZONE) private var defaults_timezone = "GMT / UTC"

    private var current_timezone_prefix = "UTC "
    private var current_time_zone = NSTimeZone(forSecondsFromGMT: 0)

    
    @Published var array_values = [
        "GMT-12", "GMT-11", "GMT-10", "GMT-9", "GMT-8", "GMT-7", "GMT-6",
        "GMT-5", "GMT-4½", "GMT-4", "GMT-3½","GMT-3", "GMT-2½", "GMT-2", "GMT-1","GMT / UTC", "GMT+1", "GMT+2",
        "GMT+3","GMT+3½", "GMT+4","GMT+4½", "GMT+5",
        "GMT+5½","GMT+6", "GMT+7", "GMT+8","GMT+9", "GMT+9½","GMT+10","GMT+11","GMT+12","GMT+13", "GMT+14"
    ]
    
    func updateTimezone(_ value: String) {
        self.defaults_timezone = value
        let defaults = UserDefaults.standard
        defaults.set( value, forKey: DEFAULTS_TIME_ZONE)
        defaults.synchronize()
        
        self.checkTimeZone()
        
        debugPrint(">> self.defaults_timezone: \(self.defaults_timezone)")
    }
    
    func checkTimeZone() {
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: DEFAULTS_TIME_ZONE) == nil) {
            defaults.set( "GMT / UTC", forKey: DEFAULTS_TIME_ZONE)
            
            self.current_time_zone = NSTimeZone(forSecondsFromGMT: 0);
            self.current_timezone_prefix = "UTC";
        } else {
            var timezone_defaults = defaults.string(forKey: DEFAULTS_TIME_ZONE)!
            
            if (timezone_defaults == "GMT / UTC") {
                self.current_time_zone = NSTimeZone(forSecondsFromGMT: 0);
                self.current_timezone_prefix = "UTC";
            } else {
                if (timezone_defaults.hasPrefix("GMT")) {
                    self.current_timezone_prefix = "\(timezone_defaults)"
                    let has_plus_half:Bool = timezone_defaults.contains("½") && timezone_defaults.contains("+");
                    let has_minus_half:Bool = timezone_defaults.contains("½") && timezone_defaults.contains("-");
                    let has_minus:Bool = timezone_defaults.contains("-") //[timezone_defaults containsString: @"-"] ;
                    
                    timezone_defaults = timezone_defaults.replacingOccurrences(of: "GMT+", with: "")
                    timezone_defaults = timezone_defaults.replacingOccurrences(of: "GMT-", with: "")
                    timezone_defaults = timezone_defaults.replacingOccurrences(of: "GMT", with: "")
                    
                    var offset:Int;
                    offset = Int(timezone_defaults.replacingOccurrences(of: "½", with: ""))! * 60 * 60;
                    
                    if (has_plus_half) {
                        offset = offset + 30 * 60;
                    } else if (has_minus_half) {
                        offset = offset + 30 * 60;
                        offset = offset * -1;
                    } else if (has_minus) {
                        offset = offset * -1;
                    }
                    self.current_time_zone = NSTimeZone(forSecondsFromGMT: offset);
                    
                } else {
                    debugPrint("StatusClock: something is really wrong")
                }
            }
        }
    }
    
    func updateTime() -> String {
        self.checkTimeZone()
        let formatter = DateFormatter()
        formatter.timeZone = self.current_time_zone as TimeZone
        if show_seconds {
            formatter.dateFormat = "HH:mm:ss"
        } else {
            formatter.dateFormat = "HH:mm"
        }
        let time_string = formatter.string(from: Date())
        
        return "\(self.current_timezone_prefix) \(time_string)"
    }

}
