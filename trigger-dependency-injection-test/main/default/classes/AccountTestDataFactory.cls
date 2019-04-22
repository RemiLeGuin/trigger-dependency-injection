@IsTest
public class AccountTestDataFactory {

	public static List<Account> createAccounts(Integer numberOfAccounts) {
		List<Account> accounts = new List<Account> ();
		for (Integer i = 0; i<numberOfAccounts; i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
		}
		insert accounts;
		return accounts;
	}

	public static List<Account> createAccountsWithAnnualRevenue(Integer numberOfAccounts) {
		List<Account> accounts = new List<Account> ();
		for (Integer i = 0; i<Integer.valueOf(numberOfAccounts * 0.25); i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
		}
		for (Integer i = Integer.valueOf(numberOfAccounts * 0.25); i<Integer.valueOf(numberOfAccounts * 0.5); i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 200000));
		}
		for (Integer i = Integer.valueOf(numberOfAccounts * 0.5); i<Integer.valueOf(numberOfAccounts * 0.75); i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 600000));
		}
		for (Integer i = Integer.valueOf(numberOfAccounts * 0.75); i<numberOfAccounts; i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 1200000));
		}
		insert accounts;
		return accounts;
	}

	public static List<Account> createAccountsWithParentAccount(Integer numberOfAccounts) {
		List<Account> parentAccounts = new List<Account> ();
		for (Integer i = 0; i<numberOfAccounts; i++) {
			parentAccounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
		}
		insert parentAccounts;
		List<Account> accounts = new List<Account> ();
		for (Integer i = 0; i<numberOfAccounts; i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'),
                                     ParentId = parentAccounts[i].Id,
                                     NumberOfEmployees = 100));
		}
		insert accounts;
		return accounts;
	}

	public static List<Account> createAccountsWithAnnualRevenueAndParentAccount(Integer numberOfAccounts) {
		List<Account> parentAccounts = new List<Account> ();
		for (Integer i = 0; i<numberOfAccounts; i++) {
			parentAccounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
		}
		insert parentAccounts;
		List<Account> accounts = new List<Account> ();
		for (Integer i = 0; i<Integer.valueOf(numberOfAccounts * 0.25); i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), ParentId = parentAccounts[i].Id));
		}
		for (Integer i = Integer.valueOf(numberOfAccounts * 0.25); i<Integer.valueOf(numberOfAccounts * 0.5); i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 200000, ParentId = parentAccounts[i].Id));
		}
		for (Integer i = Integer.valueOf(numberOfAccounts * 0.5); i<Integer.valueOf(numberOfAccounts * 0.75); i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 600000, ParentId = parentAccounts[i].Id));
		}
		for (Integer i = Integer.valueOf(numberOfAccounts * 0.75); i<numberOfAccounts; i++) {
			accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 1200000, ParentId = parentAccounts[i].Id));
		}
		insert accounts;
		return accounts;
	}

}