@IsTest
public class AccountTestDataFactoryNoDml {
    
    public static List<Account> getAccounts(Boolean insertRecords, Boolean generateId, Boolean byPassAllTriggers, Integer numberOfAccounts) {
        List<Account> accounts = new List<Account> ();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = new Account(Name = 'Account' + String.valueOf(i).leftPad(3, '0'));
            if (!insertRecords && generateId) {
                acc.Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'aaaAAAA';
            }
            accounts.add(acc);
        }
        if (insertRecords && byPassAllTriggers) {
            Caller.byPassAllTriggers = true;
            insert accounts;
            Caller.byPassAllTriggers = false;
        }
        else if (insertRecords) {
            insert accounts;
        }
        return accounts;
    }
    
    public static List<Account> getParentAccounts(Boolean insertRecords, Boolean generateId, Boolean byPassAllTriggers, Integer numberOfAccounts) {
        List<Account> accounts = new List<Account> ();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = new Account(Name = 'ParentAccount' + String.valueOf(i).leftPad(3, '0'));
            if (!insertRecords && generateId) {
                acc.Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'bbbBBBB';
            }
            accounts.add(acc);
        }
        if (insertRecords && byPassAllTriggers) {
            Caller.byPassAllTriggers = true;
            insert accounts;
            Caller.byPassAllTriggers = false;
        }
        else if (insertRecords) {
            insert accounts;
        }
        return accounts;
    }
    
    public static List<Account> getGrandParentAccounts(Boolean insertRecords, Boolean generateId, Boolean byPassAllTriggers, Integer numberOfAccounts) {
        List<Account> accounts = new List<Account> ();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = new Account(Name = 'GrandParentAccount' + String.valueOf(i).leftPad(3, '0'));
            if (!insertRecords && generateId) {
                acc.Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'cccCCCC';
            }
            accounts.add(acc);
        }
        if (insertRecords && byPassAllTriggers) {
            Caller.byPassAllTriggers = true;
            insert accounts;
            Caller.byPassAllTriggers = false;
        }
        else if (insertRecords) {
            insert accounts;
        }
        return accounts;
    }
    
    public static List<Account> getAccountsWithEmployees(Boolean insertRecords, Boolean generateId, Boolean byPassAllTriggers, Integer numberOfAccounts, Integer employees) {
        List<Account> accounts = new List<Account> ();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = new Account(Name = 'AccountWithEmployees' + String.valueOf(i).leftPad(3, '0'), NumberOfEmployees = employees);
            if (!insertRecords && generateId) {
                acc.Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'aaaAAAA';
            }
            accounts.add(acc);
        }
        if (insertRecords && byPassAllTriggers) {
            Caller.byPassAllTriggers = true;
            insert accounts;
            Caller.byPassAllTriggers = false;
        }
        else if (insertRecords) {
            insert accounts;
        }
        return accounts;
    }
    
    public static List<Account> getAccountsWithRating(Boolean insertRecords, Boolean generateId, Boolean byPassAllTriggers, Integer numberOfAccounts, String rating) {
        List<Account> accounts = new List<Account> ();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = new Account(Name = 'AccountWithRating' + String.valueOf(i).leftPad(3, '0'), Rating = rating);
            if (!insertRecords && generateId) {
                acc.Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'aaaAAAA';
            }
            accounts.add(acc);
        }
        if (insertRecords && byPassAllTriggers) {
            Caller.byPassAllTriggers = true;
            insert accounts;
            Caller.byPassAllTriggers = false;
        }
        else if (insertRecords) {
            insert accounts;
        }
        return accounts;
    }
    
    public static List<Account> getAccountsWithAnnualRevenue(Boolean insertRecords, Boolean generateId, Boolean byPassAllTriggers, Integer numberOfAccounts, Integer annualRevenue) {
        List<Account> accounts = new List<Account> ();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = new Account(Name = 'AccountWithAnnualRevenue' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = annualRevenue);
            if (!insertRecords && generateId) {
                acc.Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'aaaAAAA';
            }
            accounts.add(acc);
        }
        if (insertRecords && byPassAllTriggers) {
            Caller.byPassAllTriggers = true;
            insert accounts;
            Caller.byPassAllTriggers = false;
        }
        else if (insertRecords) {
            insert accounts;
        }
        return accounts;
    }
    
}