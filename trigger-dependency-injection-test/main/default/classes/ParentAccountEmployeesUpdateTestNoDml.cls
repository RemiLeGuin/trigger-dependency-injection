@IsTest
private class ParentAccountEmployeesUpdateTestNoDml {
    
    @IsTest
    private static void updateParentAccountEmployeesTestInsert() {
        Integer numberOfAccounts = 210;
        List<Account> parentAccounts = AccountTestDataFactoryNoDml.getParentAccounts(true, false, true, numberOfAccounts);
        List<Account> accountsWithEmployees = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, false, true, numberOfAccounts, 200);
        List<Account> accountsToTest = AccountTestDataFactoryNoDml.getAccountsWithEmployees(false, false, false, numberOfAccounts, 100);
        for (Integer i = 0; i < numberOfAccounts; i++) {
            accountsWithEmployees[i].ParentId = parentAccounts[i].Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
        }
        Caller.byPassAllTriggers = true;
        update accountsWithEmployees;
        Caller.byPassAllTriggers = false;
        
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'UpdateParentAccountEmployeesInsert' }, 'Account');
        insert accountsToTest;
        Test.stopTest();
        
        parentAccounts = [SELECT Id, NumberOfEmployees FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
        for (Integer i = 0; i < numberOfAccounts; i++) {
            System.assertEquals(300, parentAccounts[i].NumberOfEmployees, 'Wrong number of employees summarized on parent account');
        }
    }

    @IsTest
    private static void updateParentAccountEmployeesTestUpdate() {
        Integer numberOfAccounts = 210;
        List<Account> parentAccounts = AccountTestDataFactoryNoDml.getParentAccounts(true, false, true, numberOfAccounts);
        List<Account> accountsWithEmployees = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, false, true, numberOfAccounts, 200);
        List<Account> accountsToTest = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, false, true, numberOfAccounts, 10);
        for (Integer i = 0; i < numberOfAccounts; i++) {
            accountsWithEmployees[i].ParentId = parentAccounts[i].Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
        }
        Caller.byPassAllTriggers = true;
        update accountsWithEmployees;
        update accountsToTest;
        Caller.byPassAllTriggers = false;
        for (Integer i = 0; i < numberOfAccounts; i++) {
            accountsToTest[i].NumberOfEmployees = 100;
        }

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'UpdateParentAccountEmployeesUpdate' }, 'Account');
        update accountsToTest;
        Test.stopTest();

        parentAccounts = [SELECT Id, NumberOfEmployees FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
        for (Integer i = 0; i < numberOfAccounts; i++) {
            System.assertEquals(300, parentAccounts[i].NumberOfEmployees, 'Wrong number of employees summarized on parent account');
        }
    }

}