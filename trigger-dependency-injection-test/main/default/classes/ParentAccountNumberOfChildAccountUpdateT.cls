@IsTest
private class ParentAccountNumberOfChildAccountUpdateT {

	@IsTest
	private static void updateParentAccountNumberOfChildAccountInsertTest() {
		// Multiple of 4 as there are 4 test cases.
		Integer numberOfAccounts = 240;
		Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
		Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
		Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);

		Test.startTest();
		AccountTestDataFactory.createAccountsWithParentAccount(numberOfAccounts);
		Test.stopTest();

		List<Account> parentAccounts = [SELECT NumberOfChildAccount__c FROM Account WHERE ParentId = null ORDER BY Name ASC];
		System.assertEquals(1, parentAccounts[0].NumberOfChildAccount__c,
		                    'Parent account Number of Child Account set while it shall not');
		System.assertEquals(1, parentAccounts[firstQuarter].NumberOfChildAccount__c,
		                    'Parent account Number of Child Account wrong or not set');
		System.assertEquals(1, parentAccounts[secondQuarter].NumberOfChildAccount__c,
		                    'Parent account Number of Child Account wrong or not set');
		System.assertEquals(1, parentAccounts[thirdQuarter].NumberOfChildAccount__c,
		                    'Parent account Number of Child Account wrong or not set');
	}

	@IsTest
	private static void updateParentAccountNumberOfChildAccountUpdateTest() {
		// Multiple of 4 as there are 4 test cases.
		Integer numberOfAccounts = 240;
		Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
		Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
		Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);
		List<Account> parentAccounts = AccountTestDataFactory.createAccounts(numberOfAccounts);
		List<Account> childAccounts = AccountTestDataFactory.createAccounts(numberOfAccounts);
		for (Integer i = 0; i<firstQuarter; i++) {
			childAccounts[i].ParentId = parentAccounts[firstQuarter + i].Id;
		}
		for (Integer i = firstQuarter; i<secondQuarter; i++) {
			childAccounts[i].ParentId = parentAccounts[i].Id;
		}
		for (Integer i = secondQuarter; i<thirdQuarter; i++) {
			childAccounts[i].ParentId = parentAccounts[i].Id;
		}
		for (Integer i = thirdQuarter; i<numberOfAccounts; i++) {
			childAccounts[i].ParentId = parentAccounts[i].Id;
		}

		Test.startTest();
		update childAccounts;
		Test.stopTest();

		parentAccounts = [SELECT NumberOfChildAccount__c FROM Account WHERE ParentId = null ORDER BY Name ASC];
		System.assertEquals(0, parentAccounts[0].NumberOfChildAccount__c,
		                    'Parent account Number of Child Account set while it shall not');
		System.assertEquals(2, parentAccounts[firstQuarter].NumberOfChildAccount__c,
		                    'Parent account Number of Child Account wrong or not set');
		System.assertEquals(1, parentAccounts[secondQuarter].NumberOfChildAccount__c,
		                    'Parent account Number of Child Account wrong or not set');
		System.assertEquals(1, parentAccounts[thirdQuarter].NumberOfChildAccount__c,
		                    'Parent account Number of Child Account wrong or not set');
	}

}