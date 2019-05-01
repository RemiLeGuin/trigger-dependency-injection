@IsTest
private class AccountRatingUpdateTest {
    
    @IsTest
    private static void updateAccountRatingInsertTest() {
        // Multiple of 4 as there are 4 test cases.
        Integer numberOfAccounts = 240;
        Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
        Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
        Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);
        
        Test.startTest();
        AccountTestDataFactory.createAccountsWithAnnualRevenue(numberOfAccounts);
        Test.stopTest();
        
        List<Account> accounts = [SELECT AnnualRevenue, Rating FROM Account ORDER BY Name ASC];
        System.assertEquals(null, accounts[0].AnnualRevenue, 'No Account were created or Annual Revenue set while it shall not');
        System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
        System.assertEquals(200000, accounts[firstQuarter].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Cold', accounts[firstQuarter].Rating, 'Account Rating wrong or not set');
        System.assertEquals(600000, accounts[secondQuarter].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Warm', accounts[secondQuarter].Rating, 'Account Rating wrong or not set');
        System.assertEquals(1200000, accounts[thirdQuarter].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Hot', accounts[thirdQuarter].Rating, 'Account Rating wrong or not set');
    }
    
    @IsTest
    private static void updateAccountRatingUpdateTest() {
        // Multiple of 4 as there are 4 test cases.
        Integer numberOfAccounts = 240;
        Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
        Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
        Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);
        List<Account> accounts = AccountTestDataFactory.createAccounts(numberOfAccounts);
        for (Integer i = 0; i < firstQuarter; i++) {
            accounts[i].AnnualRevenue = null;
        }
        for (Integer i = firstQuarter; i < secondQuarter; i++) {
            accounts[i].AnnualRevenue = 200000;
        }
        for (Integer i = secondQuarter; i < thirdQuarter; i++) {
            accounts[i].AnnualRevenue = 600000;
        }
        for (Integer i = thirdQuarter; i < numberOfAccounts; i++) {
            accounts[i].AnnualRevenue = 1200000;
        }
        
        Test.startTest();
        update accounts;
        Test.stopTest();
        
        accounts = [SELECT AnnualRevenue, Rating FROM Account ORDER BY Name ASC];
        System.assertEquals(null, accounts[0].AnnualRevenue, 'No Account were created or Annual Revenue set while it shall not');
        System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
        System.assertEquals(200000, accounts[firstQuarter].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Cold', accounts[firstQuarter].Rating, 'Account Rating wrong or not set');
        System.assertEquals(600000, accounts[secondQuarter].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Warm', accounts[secondQuarter].Rating, 'Account Rating wrong or not set');
        System.assertEquals(1200000, accounts[thirdQuarter].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Hot', accounts[thirdQuarter].Rating, 'Account Rating wrong or not set');
    }
    
    @IsTest
    private static void updateAccountDescriptionUpdateTest() {
        // Multiple of 4 as there are 4 test cases.
        Integer numberOfAccounts = 240;
        Integer firstQuarter = Integer.valueOf(numberOfAccounts * 0.25);
        Integer secondQuarter = Integer.valueOf(numberOfAccounts * 0.5);
        Integer thirdQuarter = Integer.valueOf(numberOfAccounts * 0.75);
        List<Account> accounts = AccountTestDataFactory.createAccounts(numberOfAccounts);
        for (Integer i = 0; i < firstQuarter; i++) {
            accounts[i].AnnualRevenue = null;
        }
        for (Integer i = firstQuarter; i < secondQuarter; i++) {
            accounts[i].AnnualRevenue = 200000;
        }
        for (Integer i = secondQuarter; i < thirdQuarter; i++) {
            accounts[i].AnnualRevenue = 600000;
        }
        for (Integer i = thirdQuarter; i < numberOfAccounts; i++) {
            accounts[i].AnnualRevenue = 1200000;
        }
        
        Test.startTest();
        update accounts;
        Test.stopTest();
        
        accounts = [SELECT Description, Rating FROM Account ORDER BY Name ASC];
        System.assertEquals(null, accounts[0].Rating, 'No Account were created or Rating set while it shall not');
        System.assertEquals(null, accounts[0].Description, 'Account Description set while it shall not');
        System.assertEquals('Cold', accounts[firstQuarter].Rating, 'No Account were created or wrong Rating');
        System.assertEquals('Account is becoming Cold!', accounts[firstQuarter].Description, 'Account Description wrong or not set');
        System.assertEquals('Warm', accounts[secondQuarter].Rating, 'No Account were created or wrong Rating');
        System.assertEquals('Account is becoming Warm!', accounts[secondQuarter].Description, 'Account Description wrong or not set');
        System.assertEquals('Hot', accounts[thirdQuarter].Rating, 'No Account were created or wrong Rating');
        System.assertEquals('Account is becoming Hot!', accounts[thirdQuarter].Description, 'Account Description wrong or not set');
    }
    
}