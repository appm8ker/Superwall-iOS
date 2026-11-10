//
//  PromotionalOffer.swift
//  SuperwallKit
//

import Foundation

/// A subscription promotional offer and the signature that authorizes it.
///
/// Your server signs the JWS with your In-App Purchase key. See
/// [Generating JWS to sign App Store requests](https://developer.apple.com/documentation/storekit/generating-jws-to-sign-app-store-requests).
public struct PromotionalOffer: Sendable {
  /// The offer's identifier in App Store Connect.
  public let offerId: String

  /// The JWS compact serialization your server signed for this purchase.
  public let compactJWS: String

  public init(offerId: String, compactJWS: String) {
    self.offerId = offerId
    self.compactJWS = compactJWS
  }
}
