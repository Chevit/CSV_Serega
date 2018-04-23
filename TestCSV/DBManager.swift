//
//  DBManager.swift
//  TestCSV
//
//  Created by Vitalii Cherepakha on 4/22/18.
//  Copyright © 2018 Vitalii Cherepakha. All rights reserved.
//

import Cocoa
import MagicalRecord

class DBManager: NSObject {
    static let shared = DBManager()
    
    override init() {
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "CSV")
    }
    
    lazy var duplicatedUsers:[String] = {
        return [String]()
    }()
    
    func updateMinFinUsers(_ users:[[String]])
    {
        MagicalRecord.save(blockAndWait:{ (context) in
            
            for userData in users
            {
                var name:String
                var ips:String
                var psp:String
                var birth:String
                
                if userData.count >= 4
                {
                    name = userData[0]
                    ips = userData[1]
                    psp = userData[2]
                    birth = userData[3]
                }
                else
                {
                    print("Wrong data")
                    continue
                }
                
                let newUser = User.mr_createEntity(in: context)
                newUser?.name = name
                newUser?.ips = ips
                newUser?.psp = psp
                newUser?.birth = birth
            }
        })
    }
    
    func updateUsersAdditional(_ users:[[String]])
    {
        MagicalRecord.save(blockAndWait:{ (context) in
            
            for userData in users
            {
                var accountNumber: String?
                var birth: String
                var currencyId: Int32
                var firstMove: String?
                var id: String?
                var ips: String?
                var lastMove: String?
                var name: String?
                var psp: String?
                var summaNow: Double
                
                if userData.count >= 10
                {
                    accountNumber = userData[1]
                    birth = userData[5]
                    currencyId = Int32(userData[6]) ?? -1
                    firstMove = userData[8]
                    id = userData[0]
                    ips = userData[3]
                    lastMove = userData[9]
                    name = userData[2]
                    psp = userData[4]
                    summaNow = Double(userData[7]) ?? 0.0
                }
                else
                {
                    print("Wrong data")
                    continue
                }
                
                let newUser = UserInternalAdditional.mr_createEntity(in: context)
                newUser?.name = name
                newUser?.ips = ips
                newUser?.psp = psp
                newUser?.birth = birth
                newUser?.accountNumber = accountNumber
                newUser?.currencyId = currencyId
                newUser?.firstMove = firstMove
                newUser?.lastMove = lastMove
                newUser?.summaNow = summaNow
                newUser?.id = id
            }
        })
    }
    
    func updateUsers(_ users:[[String]])
    {
        MagicalRecord.save(blockAndWait:{ (context) in
            
            for userData in users
            {
                var accountNumber: String?
                var birth: String?
                var currencyId: Int32
                var firstMove: String?
                var id: String?
                var ips: String?
                var lastMove: String?
                var name: String?
                var psp: String?
                var summaNow: Double
                
                if userData.count >= 10
                {
                    accountNumber = userData[1]
                    birth = userData[5]
                    currencyId = Int32(userData[6]) ?? -1
                    firstMove = userData[8]
                    id = userData[0]
                    ips = userData[3]
                    lastMove = userData[9]
                    name = userData[2]
                    psp = userData[4]
                    summaNow = Double(userData[7]) ?? 0.0
                }
                else
                {
                    print("Wrong data")
                    continue
                }
                
                let newUser = UserInternal.mr_createEntity(in: context)
                newUser?.name = name
                newUser?.ips = ips
                newUser?.psp = psp
                newUser?.birth = birth
                newUser?.accountNumber = accountNumber
                newUser?.currencyId = currencyId
                newUser?.firstMove = firstMove
                newUser?.lastMove = lastMove
                newUser?.summaNow = summaNow
                newUser?.id = id
            }
        })
    }
    
    func save()
    {
        try? NSManagedObjectContext.mr_default().save()
    }
}
