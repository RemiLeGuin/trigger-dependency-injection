@IsTest
private class ParentAccountEmployeesUpdateTest {

	@IsTest
	private static void updateParentAccountEmployeesInsertTest() {
		// Multiple of 4 as there are 4 test cases.
		Integer numberOfAccounts = 240;
		Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
		Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
		Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);

		Test.startTest();
		AccountTestDataFactory.createAccountsWithParentAccount(numberOfAccounts);
		Test.stopTest();

		List<Account> parentAccounts = [SELECT NumberOfEmployees FROM Account WHERE ParentId = null ORDER BY Name ASC];
		System.assertEquals(100, parentAccounts[0].NumberOfEmployees,
		                    'Parent account Number of Employees wrong or not set');
		System.assertEquals(100, parentAccounts[firstQuarter].NumberOfEmployees,
		                    'Parent account Number of Employees wrong or not set');
		System.assertEquals(100, parentAccounts[secondQuarter].NumberOfEmployees,
		                    'Parent account Number of Employees wrong or not set');
		System.assertEquals(100, parentAccounts[thirdQuarter].NumberOfEmployees,
		                    'Parent account Number of Employees wrong or not set');
	}

	@IsTest
	private static void updateParentAccountEmployeesUpdateTest() {
		// Multiple of 4 as there are 4 test cases.
		Integer numberOfAccounts = 240;
		Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
		Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
		Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);
		Account grandparentAccount = AccountTestDataFactory.createAccounts(1)[0];
		List<Account> parentAccounts = AccountTestDataFactory.createAccounts(numberOfAccounts);
		List<Account> childAccounts = AccountTestDataFactory.createAccounts(numberOfAccounts);
		for (Integer i = 0; i<firstQuarter; i++) {
			childAccounts[i].Name = 'Child' + String.valueOf(i).leftPad(3, '0');
			childAccounts[i].NumberOfEmployees = 100;
			childAccounts[i].ParentId = parentAccounts[firstQuarter + i].Id;
			parentAccounts[i].Name = 'Parent' + String.valueOf(i).leftPad(3, '0');
			parentAccounts[i].ParentId = grandparentAccount.Id;
		}
		for (Integer i = firstQuarter; i<secondQuarter; i++) {
			childAccounts[i].Name = 'Child' + String.valueOf(i).leftPad(3, '0');
			childAccounts[i].NumberOfEmployees = 100;
			childAccounts[i].ParentId = parentAccounts[i].Id;
			parentAccounts[i].Name = 'Parent' + String.valueOf(i).leftPad(3, '0');
			parentAccounts[i].ParentId = grandparentAccount.Id;
		}
		for (Integer i = secondQuarter; i<thirdQuarter; i++) {
			childAccounts[i].Name = 'Child' + String.valueOf(i).leftPad(3, '0');
			childAccounts[i].NumberOfEmployees = 100;
			childAccounts[i].ParentId = parentAccounts[i].Id;
			parentAccounts[i].Name = 'Parent' + String.valueOf(i).leftPad(3, '0');
			parentAccounts[i].ParentId = grandparentAccount.Id;
		}
		for (Integer i = thirdQuarter; i<numberOfAccounts; i++) {
			childAccounts[i].Name = 'Child' + String.valueOf(i).leftPad(3, '0');
			childAccounts[i].ParentId = parentAccounts[i].Id;
			parentAccounts[i].Name = 'Parent' + String.valueOf(i).leftPad(3, '0');
			parentAccounts[i].ParentId = grandparentAccount.Id;
		}
		update parentAccounts;

		Test.startTest();
		update childAccounts;
		Test.stopTest();

		parentAccounts = [SELECT NumberOfEmployees FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
		grandparentAccount = [SELECT NumberOfEmployees FROM Account WHERE ParentId = null LIMIT 1];
		System.assertEquals(null, parentAccounts[0].NumberOfEmployees,
		                    'Parent account Number of Employees set while it shall not');
		System.assertEquals(200, parentAccounts[firstQuarter].NumberOfEmployees,
		                    'Parent account Number of Employees wrong or not set');
		System.assertEquals(100, parentAccounts[secondQuarter].NumberOfEmployees,
		                    'Parent account Number of Employees wrong or not set');
		System.assertEquals(null, parentAccounts[thirdQuarter].NumberOfEmployees,
		                    'Parent account Number of Employees wrong or not set');
		System.assertEquals(numberOfAccounts*0.75*100, grandparentAccount.NumberOfEmployees,
		                    'Grandparent account Number of Employees wrong or not set');
	}

}