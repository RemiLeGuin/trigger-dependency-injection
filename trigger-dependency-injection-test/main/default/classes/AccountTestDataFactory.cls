@IsTest
public class AccountTestDataFactory {

    public static void createAccounts(Integer numberOfAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i < numberOfAccounts; i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
        }
        insert accounts;
    }

}