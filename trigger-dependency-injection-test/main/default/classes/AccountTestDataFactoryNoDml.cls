@IsTest
public class AccountTestDataFactoryNoDml {

    public static List<Account> getAccountsWithRating(String rating, Integer numberOfAccounts) {
		List<Account> accounts = new List<Account> ();
		for (Integer i = 0; i < numberOfAccounts; i++) {
			accounts.add(new Account(Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'aaaAAAA',
                                     Name = 'Test' + String.valueOf(i).leftPad(3, '0'),
                                     Rating = rating));
		}
		return accounts;
	}

	public static List<Account> getAccountsWithAnnualRevenue(Integer annualRevenue, Integer numberOfAccounts) {
		List<Account> accounts = new List<Account> ();
		for (Integer i = 0; i < numberOfAccounts; i++) {
			accounts.add(new Account(Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'aaaAAAA',
                                     Name = 'Test' + String.valueOf(i).leftPad(3, '0'),
                                     AnnualRevenue = annualRevenue));
		}
		return accounts;
	}

}