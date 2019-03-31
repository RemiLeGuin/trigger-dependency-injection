@IsTest
private class ParentAccountRatingUpdateTest {

    @IsTest
    private static void insertTest() {
        // Multiple of 4 as there are 4 test cases.
        Integer numberOfAccounts = 4;
        Integer firstQuarter = Integer.valueOf(numberOfAccounts*0.25);
        Integer secondQuarter = Integer.valueOf(numberOfAccounts*0.5);
        Integer thirdQuarter = Integer.valueOf(numberOfAccounts*0.75);
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
    private static void updateTest() {
        // Multiple of 4 as there are 4 test cases.
        Integer numberOfAccounts = 4;
        Integer firstQuarter = Integer.valueOf(numberOfAccounts*0.25);
        Integer secondQuarter = Integer.valueOf(numberOfAccounts*0.5);
        Integer thirdQuarter = Integer.valueOf(numberOfAccounts*0.75);
        List<Account> accounts = AccountTestDataFactory.createAccountsWithParentAccount(numberOfAccounts);
        for(Integer i = 0; i < firstQuarter; i++) {
            accounts[i].Rating = null;
        }
        for(Integer i = firstQuarter; i < secondQuarter; i++) {
            accounts[i].Rating = 'Cold';
        }
        for(Integer i = secondQuarter; i < thirdQuarter; i++) {
            accounts[i].Rating = 'Warm';
        }
        for(Integer i = thirdQuarter; i < numberOfAccounts; i++) {
            accounts[i].Rating = 'Hot';
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

}