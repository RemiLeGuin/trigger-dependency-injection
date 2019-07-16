@IsTest
private class ParentAccountEmployeesUpdateTestNoDml {

    @IsTest
    private static void updateParentAccountEmployeesTest() {
        Integer numberOfAccounts = 1;
        List<Account> parentAccounts = AccountTestDataFactoryNoDml.getParentAccounts(true, true, numberOfAccounts);
        List<Account> accountsWithEmployees = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, true, numberOfAccounts, 200);
        List<Account> accountsToTest = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, true, numberOfAccounts, 100);
        Map<Id, Account> oldAccountsToTest = new Map<Id, Account> (AccountTestDataFactoryNoDml.getAccountsWithEmployees(false, false, numberOfAccounts, 10));
        for(Integer i = 0; i < numberOfAccounts; i++) {
            accountsWithEmployees[i].ParentId = parentAccounts[i].Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
            oldAccountsToTest.values()[i].ParentId = parentAccounts[i].Id;
        }
        Caller.byPassAllTriggers = true;
        update accountsWithEmployees;
        update accountsToTest;
        Caller.byPassAllTriggers = false;
        for(Integer i = 0; i < numberOfAccounts; i++) {
            accountsToTest[i].Id = '00100000' + String.valueOf(i).leftPad(3, '0') + 'aaaAAAA';
        }
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accountsToTest,
            'parameter2' => oldAccountsToTest
        };
                    
        Test.startTest();
        Callable callableClass = (Callable)Type.forName('ParentAccountEmployeesUpdate').newInstance();
        callableClass.call('updateParentAccountEmployees', parameters);
        Test.stopTest();

        parentAccounts = [SELECT Id, NumberOfEmployees FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
        System.assertEquals(300, parentAccounts[0].NumberOfEmployees, 'Wrong number of employees summarized on parent account');
    }

    @IsTest
    private static void byPassTest() {
        Caller.bypassedMethods = 'toutes';
        insert new Account(Name = 'Account');
        System.debug(Caller.bypassedMethods);
    }

}