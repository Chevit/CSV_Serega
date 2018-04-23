//
//  ViewController.swift
//  TestCSV
//
//  Created by Vitalii Cherepakha on 4/22/18.
//  Copyright © 2018 Vitalii Cherepakha. All rights reserved.
//

import Cocoa
import CSV
//import xlsxwriter

class ViewController: NSViewController {

    let step:Int = 5000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = DBManager.shared
//        parseUser()
//        parseUserAdditional()
//        parseMinFin()
        
        analyze()
    }
    
    func analyze()
    {
        if let users = UserInternal.mr_findAll() as? [UserInternal]
        {
            let userInternalIps = users.compactMap({ $0.ips})

            if let result = User.mr_findAll(with: NSPredicate(format: "%@ contains ips", argumentArray: [userInternalIps])) as? [User]
            {
                let minFinIps = result.compactMap({ $0.ips})
                
                if let userInternal = UserInternal.mr_findAllSorted(by: "name", ascending: true, with: NSPredicate(format: "%@ contains ips", argumentArray: [minFinIps])) as? [UserInternal]
                {
                    saveInternalUser(userInternal)
                    print("InternalUsers saved")
                }
                
            }
        }
        
        if let users = UserInternalAdditional.mr_findAll() as? [UserInternalAdditional]
        {
            let userInternalIps = users.compactMap({ $0.ips})
            
            if let result = User.mr_findAll(with: NSPredicate(format: "%@ contains ips", argumentArray: [userInternalIps])) as? [User]
            {
                let minFinIps = result.compactMap({ $0.ips})
                
                if let userInternal = UserInternalAdditional.mr_findAllSorted(by: "name", ascending: true, with: NSPredicate(format: "%@ contains ips", argumentArray: [minFinIps])) as? [UserInternalAdditional]
                {
                    saveInternalUserAdditional(userInternal)
                    print("saveInternalUserAdditional saved")
                }
            }
        }
        
    }
    
    func saveInternalUserAdditional(_ users:[UserInternalAdditional])
    {
        if let outputStream = OutputStream(toFileAtPath: "/Users/vitaliicherepakha/Desktop/Piu/new_users_additionals.csv", append: false), let writer = try? CSVWriter(stream: outputStream)
        {
            try? writer.write(field: "ID")
            try? writer.write(field: "ACCOUNTNO")
            try? writer.write(field: "SNAME")
            try? writer.write(field: "IDENTIFYCODE")
            try? writer.write(field: "PASSPORTNO")
            try? writer.write(field: "CLIENTBIRTHDAY")
            try? writer.write(field: "CURRENCYID")
            try? writer.write(field: "SUMMANOW")
            try? writer.write(field: "DATEFIRSTMOVE")
            try? writer.write(field: "DATELASTMOVE")
            writer.beginNewRow()
            
            for user in users
            {
                try? writer.write(field: user.id ?? "")
                try? writer.write(field: user.accountNumber ?? "")
                try? writer.write(field: user.name ?? "")
                try? writer.write(field: user.ips ?? "")
                try? writer.write(field: user.psp ?? "")
                try? writer.write(field: user.birth ?? "")
                try? writer.write(field: "\(user.currencyId)")
                try? writer.write(field: "\(user.summaNow)")
                try? writer.write(field: user.firstMove ?? "")
                try? writer.write(field: user.lastMove ?? "")
                writer.beginNewRow()
            }
        }
    }
    
    func saveInternalUser(_ users:[UserInternal])
    {
        if let outputStream = OutputStream(toFileAtPath: "/Users/vitaliicherepakha/Desktop/Piu/new_users.csv", append: false), let writer = try? CSVWriter(stream: outputStream)
        {//ID,ACCOUNTNO,SNAME,IDENTIFYCODE,PASSPORTNO,CLIENTBIRTHDAY,CURRENCYID,SUMMANOW,DATEFIRSTMOVE,DATELASTMOVE
            try? writer.write(field: "ID")
            try? writer.write(field: "ACCOUNTNO")
            try? writer.write(field: "SNAME")
            try? writer.write(field: "IDENTIFYCODE")
            try? writer.write(field: "PASSPORTNO")
            try? writer.write(field: "CLIENTBIRTHDAY")
            try? writer.write(field: "CURRENCYID")
            try? writer.write(field: "SUMMANOW")
            try? writer.write(field: "DATEFIRSTMOVE")
            try? writer.write(field: "DATELASTMOVE")
            writer.beginNewRow()
            for user in users
            {
                try? writer.write(field: user.id ?? "")
                try? writer.write(field: user.accountNumber ?? "")
                try? writer.write(field: user.name ?? "")
                try? writer.write(field: user.ips ?? "")
                try? writer.write(field: user.psp ?? "")
                try? writer.write(field: user.birth ?? "")
                try? writer.write(field: "\(user.currencyId)")
                try? writer.write(field: "\(user.summaNow)")
                try? writer.write(field: user.firstMove ?? "")
                try? writer.write(field: user.lastMove ?? "")
                writer.beginNewRow()
            }
        }
    }
    
    func parseMinFin()
    {
        guard User.mr_countOfEntities() == 0 else
        {
            print("parseMinFin already finished")
            return
        }
        
        var users:[[String]] = [[String]]()
        
        var counter:Int = 0
        
        if let url = Bundle.main.url(forResource: "MINFIN_BANKS_VPO.csv", withExtension: "0")
        {
            if let stream = InputStream(url: url)
            {
                
                if let file = try? CSV(stream: stream)
                {
                    while let row = file.next()
                    {
                        users.append(row)
                        let partial = users.count.remainderReportingOverflow(dividingBy: step).partialValue
                        if partial == 0
                        {
                            counter += 1
                            print(counter * step)
                            DBManager.shared.updateMinFinUsers(users)
                            users.removeAll()
                        }
                    }
                }
                
            }
        }
        
        counter = 0
        DBManager.shared.updateMinFinUsers(users)
        users.removeAll()
        
        if let url = Bundle.main.url(forResource: "MINFIN_BANKS_VPO.csv", withExtension: "1")
        {
            if let stream = InputStream(url: url)
            {
                
                if let file = try? CSV(stream: stream)
                {
                    while let row = file.next()
                    {
                        users.append(row)
                        let partial = users.count.remainderReportingOverflow(dividingBy: step).partialValue
                        if partial == 0
                        {
                            counter += 1
                            print(counter * step)
                            DBManager.shared.updateMinFinUsers(users)
                            users.removeAll()
                        }
                    }
                }
                
            }
        }
        
        DBManager.shared.updateMinFinUsers(users)
        users.removeAll()
        
        print("\nFinished\n")
        print("\nTotal count - \(User.mr_countOfEntities())\n")
        
        DBManager.shared.save()
    }
    
    func parseUser()
    {
        guard UserInternal.mr_countOfEntities() == 0 else
        {
            print("parseUser already finished")
            return
        }
        
        var users:[[String]] = [[String]]()
        
        var counter:Int = 0
        
        if let url = Bundle.main.url(forResource: "users_2635", withExtension: "csv")
        {
            if let stream = InputStream(url: url)
            {
                
                if let file = try? CSV(stream: stream)
                {
                    while let row = file.next()
                    {
                        users.append(row)
                        let partial = users.count.remainderReportingOverflow(dividingBy: step).partialValue
                        if partial == 0
                        {
                            counter += 1
                            print(counter * step)
                            DBManager.shared.updateUsers(users)
                            users.removeAll()
                        }
                    }
                }
                
            }
        }
        
        counter = 0
        DBManager.shared.updateUsers(users)
        users.removeAll()
        
        print("\nFinished\n")
        print("\nUserInternal Total count - \(UserInternal.mr_countOfEntities())\n")
        
        DBManager.shared.save()
    }
    
    func parseUserAdditional()
    {
        guard UserInternalAdditional.mr_countOfEntities() == 0 else
        {
            print("parseUserAdditional already finished")
            return
        }
        
        var users:[[String]] = [[String]]()
        
        var counter:Int = 0
        
        if let url = Bundle.main.url(forResource: "users", withExtension: "csv")
        {
            if let stream = InputStream(url: url)
            {
                
                if let file = try? CSV(stream: stream)
                {
                    while let row = file.next()
                    {
                        users.append(row)
                        let partial = users.count.remainderReportingOverflow(dividingBy: step).partialValue
                        if partial == 0
                        {
                            counter += 1
                            print(counter * step)
                            DBManager.shared.updateUsersAdditional(users)
                            users.removeAll()
                        }
                    }
                }
                
            }
        }
        
        DBManager.shared.updateUsersAdditional(users)
        users.removeAll()
        
        print("\nFinished\n")
        print("\nUserInternalAdditional Total count - \(UserInternalAdditional.mr_countOfEntities())\n")
        
        DBManager.shared.save()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

