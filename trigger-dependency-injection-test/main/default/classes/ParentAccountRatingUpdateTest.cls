@IsTest
private class ParentAccountRatingUpdateTest {

	@IsTest
	private static void updateParentAccountRatingInsertTest() {
		// Multiple of 4 as there are 4 test cases.
		Integer numberOfAccounts = 240;
		Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
		Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
		Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);

		Test.startTest();
		AccountTestDataFactory.createAccountsWithAnnualRevenueAndParentAccount(numberOfAccounts);
		Test.stopTest();

		List<Account> accounts = [SELECT Rating FROM Account WHERE ParentId != null ORDER BY Name ASC];
		List<Account> parentAccounts = [SELECT Rating FROM Account WHERE ParentId = null ORDER BY Name ASC];
		System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
		System.assertEquals(null, parentAccounts[0].Rating, 'Parent account Rating set while it shall not');
		System.assertEquals('Cold', accounts[firstQuarter].Rating, 'Account Rating wrong or not set');
		System.assertEquals('Cold', parentAccounts[firstQuarter].Rating, 'Parent account Rating wrong or not set');
		System.assertEquals('Warm', accounts[secondQuarter].Rating, 'Account Rating wrong or not set');
		System.assertEquals('Warm', parentAccounts[secondQuarter].Rating, 'Parent account Rating wrong or not set');
		System.assertEquals('Hot', accounts[thirdQuarter].Rating, 'Account Rating wrong or not set');
		System.assertEquals('Hot', parentAccounts[thirdQuarter].Rating, 'Parent account Rating wrong or not set');
	}

	@IsTest
	private static void updateParentAccountRatingUpdateTest() {
		// Multiple of 4 as there are 4 test cases.
		Integer numberOfAccounts = 240;
		Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
		Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
		Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);
		List<Account> accounts = AccountTestDataFactory.createAccountsWithParentAccount(numberOfAccounts);
		for (Integer i = 0; i<firstQuarter; i++) {
			accounts[i].AnnualRevenue = null;
		}
		for (Integer i = firstQuarter; i<secondQuarter; i++) {
			accounts[i].AnnualRevenue = 200000;
		}
		for (Integer i = secondQuarter; i<thirdQuarter; i++) {
			accounts[i].AnnualRevenue = 600000;
		}
		for (Integer i = thirdQuarter; i<numberOfAccounts; i++) {
			accounts[i].AnnualRevenue = 1200000;
		}

		Test.startTest();
		update accounts;
		Test.stopTest();

		accounts = [SELECT Rating FROM Account WHERE ParentId != null ORDER BY Name ASC];
		List<Account> parentAccounts = [SELECT Rating FROM Account WHERE ParentId = null ORDER BY Name ASC];
		System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
		System.assertEquals(null, parentAccounts[0].Rating, 'Parent account Rating set while it shall not');
		System.assertEquals('Cold', accounts[firstQuarter].Rating, 'Account Rating wrong or not set');
		System.assertEquals('Cold', parentAccounts[firstQuarter].Rating, 'Parent account Rating wrong or not set');
		System.assertEquals('Warm', accounts[secondQuarter].Rating, 'Account Rating wrong or not set');
		System.assertEquals('Warm', parentAccounts[secondQuarter].Rating, 'Parent account Rating wrong or not set');
		System.assertEquals('Hot', accounts[thirdQuarter].Rating, 'Account Rating wrong or not set');
		System.assertEquals('Hot', parentAccounts[thirdQuarter].Rating, 'Parent account Rating wrong or not set');
	}

	@IsTest
	private static void updateParentAccountRatingUndeleteTest() {
		// Multiple of 3 as there are 3 test cases.
		Integer numberOfAccounts = 240;
		Integer firstTier = Integer.valueOf(numberOfAccounts * 0.333334);
		Integer secondTier = Integer.valueOf(numberOfAccounts * 0.666667);
		List<Account> accounts = AccountTestDataFactory.createAccountsWithAnnualRevenueAndParentAccountNoHot(numberOfAccounts);
		delete accounts;

		Test.startTest();
		undelete accounts;
		Test.stopTest();

		accounts = [SELECT Rating FROM Account WHERE Name LIKE 'Child%' ORDER BY Name ASC];
		List<Account> parentAccounts = [SELECT Rating FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
		List<Account> grandparentAccounts = [SELECT Rating FROM Account WHERE Name LIKE 'Grandparent%' ORDER BY Name ASC];
		System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
		System.assertEquals(null, parentAccounts[0].Rating, 'Parent account Rating set while it shall not');
		System.assertEquals(null, grandparentAccounts[0].Rating, 'Grandparent account Rating set while it shall not');
		System.assertEquals('Cold', accounts[firstTier].Rating, 'Account Rating wrong or not set');
		System.assertEquals('Cold', parentAccounts[firstTier].Rating, 'Parent account Rating wrong or not set');
		System.assertEquals('Cold', grandparentAccounts[firstTier].Rating, 'Grandparent account Rating wrong or not set');
		System.assertEquals('Warm', accounts[secondTier].Rating, 'Account Rating wrong or not set');
		System.assertEquals('Warm', parentAccounts[secondTier].Rating, 'Parent account Rating wrong or not set');
		System.assertEquals('Warm', grandparentAccounts[secondTier].Rating, 'Grandparent account Rating wrong or not set');
	}

}