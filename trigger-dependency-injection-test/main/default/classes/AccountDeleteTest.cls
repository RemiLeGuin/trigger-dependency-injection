@IsTest
private class AccountDeleteTest {
    
    @IsTest
    private static void checkAccountRatingDeleteTest() {
        // Multiple of 4 as there are 4 test cases.
        Integer numberOfAccounts = 240;
        Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
        Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
        Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);
        List<Account> accounts = AccountTestDataFactory.createAccountsWithAnnualRevenue(numberOfAccounts);
        
        Test.startTest();
        List<Database.DeleteResult> results = Database.delete(accounts, false);
        Test.stopTest();
        
        accounts = [SELECT Rating FROM Account ORDER BY Name ASC];
        System.assert(results[0].isSuccess(), 'Delete failed while the Account Rating is null');
        System.assert(results[firstQuarter].isSuccess(), 'Delete failed while the Account Rating is \'Cold\'');
        System.assert(results[secondQuarter].isSuccess(), 'Delete failed while the Account Rating is \'Warm\'');
        System.assert(!results[thirdQuarter].isSuccess(), 'Delete succeed while the Account Rating is \'Hot\'');
        System.assertEquals(Label.ErrorOnDeleteRating, results[thirdQuarter].getErrors() [0].getMessage(),
                            'Wrong error message displayed on trying to delete a \'Hot\' Account');
    }
    
}