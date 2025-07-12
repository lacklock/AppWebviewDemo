import SwiftUI
import UIKit  // 添加这行

// 震动反馈工具类
struct HapticFeedback {
    // 轻微震动 - 用于状态切换
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    // 中等震动 - 用于重要操作
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    // 重度震动 - 用于警告或重要提示
    static func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    static func rigid() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
        impactFeedback.impactOccurred()
    }
    
    static func soft() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
        impactFeedback.impactOccurred()
    }
    
    // 选择反馈 - 用于选择操作
    static func selection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
    
    // 通知反馈 - 用于成功/错误/警告
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }
}
