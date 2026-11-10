//
//  StoreProductPromotionalOfferTests.swift
//  SuperwallKitTests
//
// swiftlint:disable all

import Foundation
import Testing
@testable import SuperwallKit

@Suite("StoreProduct promotional offer")
struct StoreProductPromotionalOfferTests {
  let offer = PromotionalOffer(offerId: "black_basic_26", compactJWS: "header.payload.signature")

  @Test("The offer goes on a copy, never on the product itself")
  func offerGoesOnACopy() {
    let product = StoreProduct(
      sk1Product: MockSkProduct(productIdentifier: "com.app.annual"),
      entitlements: []
    )

    let discounted = product.withPromotionalOffer(offer)

    #expect(discounted !== product)
    #expect(discounted.productIdentifier == "com.app.annual")
    #expect(discounted.promotionalOffer?.offerId == "black_basic_26")
    #expect(discounted.promotionalOffer?.compactJWS == "header.payload.signature")
    #expect(product.promotionalOffer == nil)
  }

  @Test("StoreKit 1 fails the purchase instead of charging the regular price")
  func storeKit1FailsThePurchase() async {
    let dependencyContainer = DependencyContainer()
    let purchaser = ProductPurchaserSK1(
      shouldFinishTransactions: true,
      storeKitManager: dependencyContainer.storeKitManager,
      receiptManager: dependencyContainer.receiptManager,
      identityManager: dependencyContainer.identityManager,
      coordinator: PurchasingCoordinator(factory: dependencyContainer),
      storage: dependencyContainer.storage,
      factory: dependencyContainer
    )
    let product = StoreProduct(
      sk1Product: MockSkProduct(productIdentifier: "com.app.annual"),
      entitlements: []
    ).withPromotionalOffer(offer)

    let result = await purchaser.purchase(product: product)

    guard
      case .failed(let error) = result,
      case .promotionalOfferNeedsStoreKit2? = error as? PurchaseError
    else {
      Issue.record("Expected the StoreKit 2 failure, got \(result)")
      return
    }
  }
}
