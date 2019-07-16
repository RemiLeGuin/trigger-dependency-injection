@IsTest
private class ParentAccountEmployeesUpdateTestNoDml {

    @IsTest
    private static void updateParentAccountEmployeesTest() {
        List<Account> parentAccounts = AccountTestDataFactoryNoDml.getParentAccounts(false, false, 200);
        List<Account> accountsWithEmployees = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, true, 200, 200);
        List<Account> accountsToTest = AccountTestDataFactoryNoDml.getAccountsWithEmployees(true, true, 200, 100);
        for(Integer i = 0; i < 200; i++) {
            accountsWithEmployees[i].ParentId = '00100000' + String.valueOf(i).leftPad(3, '0') + 'bbbBBBB';
            accountsToTest[i].ParentId = '00100000' + String.valueOf(i).leftPad(3, '0') + 'bbbBBBB';
        }
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accountsToTest,
            'parameter2' => null
        };
                    
        Test.startTest();
        Callable callableClass = (Callable)Type.forName('ParentAccountEmployeesUpdate').newInstance();
        callableClass.call('updateParentAccountEmployees', parameters);
        Test.stopTest();

        System.assertEquals(300, parentAccounts[0].NumberOfEmployees, 'Wrong number of employees summarized on parent account');
    }

}