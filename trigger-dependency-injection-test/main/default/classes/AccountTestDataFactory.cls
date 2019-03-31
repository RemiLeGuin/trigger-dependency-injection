@IsTest
public class AccountTestDataFactory {

    public static List<Account> createAccounts(Integer numberOfAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i < numberOfAccounts; i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
        }
        insert accounts;
        return accounts;
    }

    public static List<Account> createAccountsWithAnnualRevenue(Integer numberOfAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < Integer.valueOf(numberOfAccounts*0.25); i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
        }
        for(Integer i = Integer.valueOf(numberOfAccounts*0.25); i < Integer.valueOf(numberOfAccounts*0.5); i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 200000, Industry = 'Agriculture'));
        }
        for(Integer i = Integer.valueOf(numberOfAccounts*0.5); i < Integer.valueOf(numberOfAccounts*0.75); i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 600000, Industry = 'Agriculture'));
        }
        for(Integer i = Integer.valueOf(numberOfAccounts*0.75); i < numberOfAccounts; i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 1200000, Industry = 'Agriculture'));
        }
        insert accounts;
        return accounts;
    }

}