//
//  VolticStripeHelper.swift
//  Servin
//
//  Created by Munib Rahman on 2019-09-20.
//  Copyright © 2019 Voltic Labs. All rights reserved.
//

import Foundation
import Stripe
import AWSAppSync
import SwiftyJSON

class VolticStripeHelper: NSObject {
    
    private override init() {
    }
    
    static let shared = VolticStripeHelper()
    
    
    
    // MARK:- MUTATIONS (Reflecting all of the mutations in the GraphQL Schema)
    
    
    func createExternalAccount(name: String,
                               transit: String,
                               institution: String,
                               account: String,
                               onSuccess: @escaping () -> Void,
                               onError: @escaping (Error?) -> Void) {
        
        let STPBankAccount = STPBankAccountParams.init()
        STPBankAccount.accountHolderName = name
        STPBankAccount.accountNumber = account
        STPBankAccount.accountHolderType = STPBankAccountHolderType.individual
        STPBankAccount.routingNumber = transit + institution
        STPBankAccount.country = "CA" // TODO: When stripe goes international, will need to change this value
        STPBankAccount.currency = "CAD" // TODO: Possibly give an option to use international currency?
        
        STPAPIClient.shared().createToken(withBankAccount: STPBankAccount, completion: { (token, error) in
            if let token = token {
                print("Successfully created bank account token")
                print(token.tokenId)
                print(token)
                
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    let appSyncClient = appDelegate.appSyncClient
                    
                    let mutation = CreateExternalAccountMutation.init(external_account_token: token.tokenId)
                    
                    appSyncClient?.perform(mutation: mutation,
                                           queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                           resultHandler: { (result, error) in
                                            
                                            
                                            if let result = result {
                                                print("Successfully added external account")
                                                print(result)
                                                onSuccess()
                                            } else if let error = error {
                                                print("Error adding external account")
                                                print(error)
                                                print(error.localizedDescription)
                                                onError(error)
                                            }
                    })
                }
                
                
            } else if let error = error {
                print("Error creating external account token")
                print(error)
                print(error.localizedDescription)
                onError(error)
            }
        })
    }
    
    func deleteExternalAccount(id: String,
                               onSuccess: @escaping () -> Void,
                               onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = DeleteExternalAccountMutation.init(id: id)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully deleted external account")
                                        print(result)
                                        onSuccess()
                                    } else if let error = error {
                                        print("Error deleting external account")
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    
    
    func updateExternalBankAccount(input: BankAccountInput,
                                   onSuccess: @escaping () -> Void,
                                   onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = UpdateExternalBankAccountMutation.init(input: input)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully updated external account")
                                        print(result)
                                        onSuccess()
                                    } else if let error = error {
                                        print("Error updating external account")
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func updateExternalDebitCard(input: DebitCardInput,
                                   onSuccess: @escaping () -> Void,
                                   onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = UpdateExternalDebitCardMutation.init(input: input)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully updated debit card")
                                        print(result)
                                        onSuccess()
                                    } else if let error = error {
                                        print("Error updating debit card")
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func createPaymentIntent(input: PaymentIntentInput,
                                 onSuccess: @escaping () -> Void,
                                 onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = CreatePaymentIntentMutation.init(input: input)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully created payment intent")
                                        print(result)
                                        onSuccess()
                                    } else if let error = error {
                                        print("Error creating payment intent")
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func cancelPaymentIntent(id: String,
                             onSuccess: @escaping () -> Void,
                             onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = CancelPaymentIntentMutation.init(intent: id)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully cancelled payment intent")
                                        print(result)
                                        onSuccess()
                                    } else if let error = error {
                                        print("Error cancelling payment intent")
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func createSetupIntent(onSuccess: @escaping (JSON) -> Void,
                           onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = CreateSetupIntentMutation.init()
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully created setup intent")
                                        print(result)
                                        
                                        guard let jsonString = result.data?.createSetupIntent else {
                                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            return
                                        }
                                        
                                        //                    print(jsonString)
                                        
                                        if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                                            do {
                                                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                                
                                                onSuccess(json)
                                                
                                            } catch {
                                                print("Error printing json")
                                                onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            }
                                        }
                                        
                                    } else if let error = error {
                                        print("Error creating setup intent")
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func updateSetupIntent(input: UpdateSetupIntentInput,
                           onSuccess: @escaping (JSON) -> Void,
                           onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = UpdateSetupIntentMutation.init(input: input)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully updated setup intent")
                                        print(result)
                                        
                                        guard let jsonString = result.data?.updateSetupIntent else {
                                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            return
                                        }
                                        
                                        //                    print(jsonString)
                                        
                                        if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                                            do {
                                                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                                
                                                onSuccess(json)
                                                
                                            } catch {
                                                print("Error printing json")
                                                onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            }
                                        }
                                        
                                    } else if let error = error {
                                        print("Error creating setup intent")
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func confirmSetupIntent(input: ConfirmSetupIntentInput,
                           onSuccess: @escaping (JSON) -> Void,
                           onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = ConfirmSetupIntentMutation.init(input: input)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully updated setup intent")
                                        print(result)
                                        
                                        guard let jsonString = result.data?.confirmSetupIntent else {
                                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            return
                                        }
                                        
                                        //                    print(jsonString)
                                        
                                        if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                                            do {
                                                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                                
                                                onSuccess(json)
                                                
                                            } catch {
                                                print("Error printing json")
                                                onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            }
                                        }
                                        
                                    } else if let error = error {
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func cancelSetupIntent(input: CancelSetupIntentInput,
                            onSuccess: @escaping (JSON) -> Void,
                            onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = CancelSetupIntentMutation.init(input: input)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully updated setup intent")
                                        print(result)
                                        
                                        guard let jsonString = result.data?.cancelSetupIntent else {
                                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            return
                                        }
                                        
                                        //                    print(jsonString)
                                        
                                        if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                                            do {
                                                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                                
                                                onSuccess(json)
                                                
                                            } catch {
                                                print("Error printing json")
                                                onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            }
                                        }
                                        
                                    } else if let error = error {
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func updateStripeCustomer(input: UpdateStripeCustomerInput,
                           onSuccess: @escaping (JSON) -> Void,
                           onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = UpdateStripeCustomerMutation.init(input: input)
            
            appSyncClient?.perform(mutation: mutation,
                                   queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
                                   resultHandler: { (result, error) in
                                    
                                    
                                    if let result = result {
                                        print("Successfully updated setup intent")
                                        print(result)
                                        
                                        guard let jsonString = result.data?.updateStripeCustomer else {
                                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            return
                                        }
                                        
                                        //                    print(jsonString)
                                        
                                        if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                                            do {
                                                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                                
                                                onSuccess(json)
                                                
                                            } catch {
                                                print("Error printing json")
                                                onError(NSError.init(domain: "", code: 400, userInfo: nil))
                                            }
                                        }
                                        
                                    } else if let error = error {
                                        print(error)
                                        print(error.localizedDescription)
                                        onError(error)
                                    }
            })
        }
    }
    
    func attachPaymentMethod(token: String,
                             onSuccess: @escaping () -> Void,
                             onError: @escaping (Error?) -> Void) {
        
        let paymentMethodCard = STPPaymentMethodCardParams.init()
        
        paymentMethodCard.token = token
        
        let methodParams = STPPaymentMethodParams.init(card: paymentMethodCard, billingDetails: nil, metadata: nil)
        
        STPAPIClient.shared().createPaymentMethod(with: methodParams) { (method, error) in
            if let error = error {
                print(error)
//                completion(error)
                onError(error)
                return
            }
            
            if let pmToken = method?.stripeId {
                print(pmToken)
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    let appSyncClient = appDelegate.appSyncClient
                    
                    
                    let mutation = AttachPaymentMethodMutation.init(token: pmToken)
                    
                    appSyncClient?.perform(mutation: mutation, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (result, error) in
                        if let result = result {
                            print("Added card")
                            print(result)
                            
                            onSuccess()
                        }
                        
                        else if let error = error {
                            print(error)
                            onError(error)
                            return
                        }
                        
                        
                        
                    })
                    
                    
                    
                }
                
                
            }
            
            
            
            
            
        }
    }
    
    func detachPaymentMethod(id : String,
                             onSuccess: @escaping () -> Void,
                             onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            
            let mutation = DetachPaymentMethodMutation.init(token: id)
            
            appSyncClient?.perform(mutation: mutation, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (result, error) in
                if let error = error {
                    print(error)
                    onError(error)
                    return
                }
                
                print("Detached payment method")
                print(result)
                
                onSuccess()
                
            })
            
            
            
        }
    }

    
    //    MARK:- QUERIES
    
    func retrieveStripeAccount(onSuccess: @escaping (JSON) -> Void,
                               onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let query = RetrieveStripeAccountQuery.init()
            
            
            appSyncClient?.fetch(query: query, cachePolicy: CachePolicy.returnCacheDataAndFetch, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (result, error) in
                if let result = result {
                    print("Successfully updated setup intent")
                    print(result)
                    
                    guard let jsonString = result.data?.retrieveStripeAccount else {
                        onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        return
                    }
                    
                    if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                        do {
                            let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            onSuccess(json)
                            
                        } catch {
                            print("Error printing json")
                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        }
                    }
                    
                } else if let error = error {
                    print(error)
                    print(error.localizedDescription)
                    onError(error)
                }
            })
        }
    }
    
    func retrieveExternalAccount(id: String,
        onSuccess: @escaping (JSON) -> Void,
                               onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let query = RetrieveExternalAccountQuery.init(id: id)
            
            
            appSyncClient?.fetch(query: query, cachePolicy: CachePolicy.returnCacheDataAndFetch, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (result, error) in
                if let result = result {
                    print("Successfully updated setup intent")
                    print(result)
                    
                    guard let jsonString = result.data?.retrieveExternalAccount else {
                        onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        return
                    }
                    
                    if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                        do {
                            let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            onSuccess(json)
                            
                        } catch {
                            print("Error printing json")
                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        }
                    }
                    
                } else if let error = error {
                    print(error)
                    print(error.localizedDescription)
                    onError(error)
                }
            })
        }
    }
    
    func listExternalAccounts(type: ExternalAccountType,
                              limit: Int?,
                              ending_before: String?,
                              starting_after: String?,
                              onSuccess: @escaping (JSON) -> Void,
                              onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let query = ListExternalAccountsQuery.init(type: type, limit: limit, ending_before: ending_before, starting_after: starting_after)

            appSyncClient?.fetch(query: query, cachePolicy: CachePolicy.returnCacheDataAndFetch, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (result, error) in
                if let result = result {
                    
                    guard let jsonString = result.data?.listExternalAccounts else {
                        onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        return
                    }
                    
                    if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                        do {
                            let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            onSuccess(json)
                            
                        } catch {
                            print("Error printing json")
                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        }
                    }
                    
                } else if let error = error {
                    print(error)
                    print(error.localizedDescription)
                    onError(error)
                }
            })
        }
    }
    
    func retrieveBalance(onSuccess: @escaping (JSON) -> Void,
                         onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let query = RetrieveBalanceQuery.init()
            
            
            appSyncClient?.fetch(query: query, cachePolicy: CachePolicy.returnCacheDataAndFetch, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (result, error) in
                if let result = result {
                    
                    print(result)
                    
                    guard let jsonString = result.data?.retrieveBalance else {
                        onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        return
                    }
                    
                    if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                        do {
                            let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            onSuccess(json)
                            
                        } catch {
                            print("Error printing json")
                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        }
                    }
                    
                } else if let error = error {
                    print(error)
                    print(error.localizedDescription)
                    onError(error)
                }
            })
        }
    }
    
    func listPaymentMethods(input: ListPaymentMethodsInput,
                              onSuccess: @escaping (JSON) -> Void,
                              onError: @escaping (Error?) -> Void) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let query = ListPaymentMethodsQuery.init(input: input)
            
            
            appSyncClient?.fetch(query: query, cachePolicy: CachePolicy.returnCacheDataAndFetch, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (result, error) in
                if let result = result {
                    
                    guard let jsonString = result.data?.listPaymentMethods else {
                        onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        return
                    }
                    
                    if let data = jsonString.data(using: .utf8, allowLossyConversion: false) {
                        do {
                            let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            onSuccess(json)
                            
                        } catch {
                            print("Error printing json")
                            onError(NSError.init(domain: "", code: 400, userInfo: nil))
                        }
                    }
                    
                } else if let error = error {
                    print(error)
                    print(error.localizedDescription)
                    onError(error)
                }
            })
        }
    }
}
