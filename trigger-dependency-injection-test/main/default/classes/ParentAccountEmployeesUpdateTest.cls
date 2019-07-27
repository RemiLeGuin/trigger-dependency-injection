@IsTest
private class ParentAccountEmployeesUpdateTest {
    
    @IsTest
    private static void updateParentAccountEmployeesInsertTest() {
        Integer numberOfAccounts = 201;
        Account grandParentAccount = AccountTestDataFactoryNoDml.getGrandParentAccounts(true, false, true, 1)[0];
        List<Account> parentAccounts = AccountTestDataFactoryNoDml.getParentAccounts(true, false, true, numberOfAccounts);
        List<Account> accountsWithEmployees = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, false, true, numberOfAccounts, 200);
        List<Account> accountsToTest = AccountTestDataFactoryNoDml.getAccountsWithEmployees(false, false, false, numberOfAccounts, 100);
        for (Integer i = 0; i < numberOfAccounts; i++) {
            parentAccounts[i].ParentId = grandParentAccount.Id;
            accountsWithEmployees[i].ParentId = parentAccounts[i].Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
        }
        Caller.byPassAllTriggers = true;
        update parentAccounts;
        update accountsWithEmployees;
        Caller.byPassAllTriggers = false;
        
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'UpdateParentAccountEmployeesInsert', 'UpdateParentAccountEmployeesUpdate' }, 'Account');
        insert accountsToTest;
        Test.stopTest();
        
        parentAccounts = [SELECT Id, NumberOfEmployees FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
        for (Integer i = 0; i < numberOfAccounts; i++) {
            System.assertEquals(300, parentAccounts[i].NumberOfEmployees, 'Wrong number of employees summarized on parent account');
        }
        grandParentAccount = [SELECT Id, NumberOfEmployees FROM Account WHERE Name LIKE 'GrandParent%' ORDER BY Name ASC];
        System.assertEquals(numberOfAccounts * (200 + 100), grandParentAccount.NumberOfEmployees, 'Wrong number of employees summarized on grandparent account');
    }

    @IsTest
    private static void updateParentAccountEmployeesUpdateTest() {
        Integer numberOfAccounts = 201;
        Account grandParentAccount = AccountTestDataFactoryNoDml.getGrandParentAccounts(true, false, true, 1)[0];
        List<Account> parentAccounts = AccountTestDataFactoryNoDml.getParentAccounts(true, false, true, numberOfAccounts);
        List<Account> accountsWithEmployees = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, false, true, numberOfAccounts, 200);
        List<Account> accountsToTest = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, false, true, numberOfAccounts, 10);
        for (Integer i = 0; i < numberOfAccounts; i++) {
            parentAccounts[i].ParentId = grandParentAccount.Id;
            accountsWithEmployees[i].ParentId = parentAccounts[i].Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
        }
        Caller.byPassAllTriggers = true;
        update parentAccounts;
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
        grandParentAccount = [SELECT Id, NumberOfEmployees FROM Account WHERE Name LIKE 'GrandParent%' ORDER BY Name ASC];
        System.assertEquals(numberOfAccounts * (200 + 100), grandParentAccount.NumberOfEmployees, 'Wrong number of employees summarized on grandparent account');
    }

    @IsTest
    private static void updateParentAccountEmployeesDeleteTest() {
        Integer numberOfAccounts = 201;
        Account grandParentAccount = AccountTestDataFactoryNoDml.getGrandParentAccounts(true, false, true, 1)[0];
        List<Account> parentAccounts = AccountTestDataFactoryNoDml.getParentAccounts(true, false, true, numberOfAccounts);
        List<Account> accountsWithEmployees = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, false, true, numberOfAccounts, 200);
        List<Account> accountsToTest = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, false, true, numberOfAccounts, 100);
        for (Integer i = 0; i < numberOfAccounts; i++) {
            parentAccounts[i].ParentId = grandParentAccount.Id;
            accountsWithEmployees[i].ParentId = parentAccounts[i].Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
        }
        Caller.byPassAllTriggers = true;
        update parentAccounts;
        update accountsWithEmployees;
        update accountsToTest;
        Caller.byPassAllTriggers = false;

        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'UpdateParentAccountEmployeesDelete', 'UpdateParentAccountEmployeesUpdate' }, 'Account');
        delete accountsToTest;
        Test.stopTest();

        parentAccounts = [SELECT Id, NumberOfEmployees FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
        for (Integer i = 0; i < numberOfAccounts; i++) {
            System.assertEquals(200, parentAccounts[i].NumberOfEmployees, 'Wrong number of employees summarized on parent account');
        }
        grandParentAccount = [SELECT Id, NumberOfEmployees FROM Account WHERE Name LIKE 'GrandParent%' ORDER BY Name ASC];
        System.assertEquals(numberOfAccounts * 200, grandParentAccount.NumberOfEmployees, 'Wrong number of employees summarized on grandparent account');
    }
    
    @IsTest
    private static void testNonImplementedMethod() {
        String exceptionThrown;
        
        Test.startTest();
        try {
            Callable callableClass = (Callable)Type.forName('ParentAccountEmployeesUpdate').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
        Test.stopTest();
        
        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
    }
    
}