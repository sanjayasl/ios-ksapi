import Foundation
import Argo
import Curry

public struct Activity {
  public let category: Activity.Category
  public let comment: Comment?
  public let createdAt: NSTimeInterval
  public let id: Int
  public let memberData: MemberData
  public let project: Project?
  public let update: Update?
  public let user: User?

  public enum Category: String {
    case backing          = "backing"
    case backingAmount    = "backing-amount"
    case backingCanceled  = "backing-canceled"
    case backingDropped   = "backing-dropped"
    case backingReward    = "backing-reward"
    case cancellation     = "cancellation"
    case commentPost      = "comment-post"
    case commentProject   = "comment-project"
    case failure          = "failure"
    case follow           = "follow"
    case funding          = "funding"
    case launch           = "launch"
    case success          = "success"
    case suspension       = "suspension"
    case update           = "update"
    case watch            = "watch"
  }

  public struct MemberData {
    public let amount: Int?
    public let backing: Backing?
    public let oldAmount: Int?
    public let oldRewardId: Int?
    public let newAmount: Int?
    public let newRewardId: Int?
    public let rewardId: Int?
  }
}

extension Activity: Equatable {
}
public func == (lhs: Activity, rhs: Activity) -> Bool {
  return lhs.id == rhs.id
}

extension Activity.Category: Decodable {
}

extension Activity: Decodable {
  public static func decode(json: JSON) -> Decoded<Activity> {
    let create = curry(Activity.init)
    return create
      <^> json <|  "category"
      <*> json <|? "comment"
      <*> json <|  "created_at"
      <*> json <|  "id"
      <*> Activity.MemberData.decode(json)
      <*> json <|? "project"
      <*> json <|? "update"
      <*> json <|? "user"
  }
}

extension Activity.MemberData: Decodable {
  public static func decode(json: JSON) -> Decoded<Activity.MemberData> {
    return curry(Activity.MemberData.init)
      <^> json <|? "amount"
      <*> json <|? "backing"
      <*> json <|? "old_amount"
      <*> json <|? "old_reward_id"
      <*> json <|? "new_amount"
      <*> json <|? "new_reward_id"
      <*> json <|? "reward_id"
  }
}
