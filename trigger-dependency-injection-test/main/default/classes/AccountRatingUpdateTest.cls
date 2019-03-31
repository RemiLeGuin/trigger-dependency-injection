@IsTest
private class AccountRatingUpdateTest {
    /*
    @TestSetup
    private static void accountDataSetup() {
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i < 4; i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
        }
        insert accounts;
    }
    */
    @IsTest
    private static void insertTest() {
        Integer numberOfAccounts = 4;
        Test.startTest();
        List<Account> accounts = AccountTestDataFactory.createAccountsWithAnnualRevenue(numberOfAccounts);
        Test.stopTest();

        accounts = [SELECT AnnualRevenue, Rating FROM Account ORDER BY Name ASC];
        System.assertEquals(null, accounts[0].AnnualRevenue, 'No Account were created or Annual Revenue set while it shall not');
        System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
        System.assertEquals(200000, accounts[Integer.valueOf(numberOfAccounts*0.25)].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Cold', accounts[Integer.valueOf(numberOfAccounts*0.25)].Rating, 'Account Rating wrong or not set');
        System.assertEquals(600000, accounts[Integer.valueOf(numberOfAccounts*0.5)].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Warm', accounts[Integer.valueOf(numberOfAccounts*0.5)].Rating, 'Account Rating wrong or not set');
        System.assertEquals(1200000, accounts[Integer.valueOf(numberOfAccounts*0.75)].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Hot', accounts[Integer.valueOf(numberOfAccounts*0.75)].Rating, 'Account Rating wrong or not set');
    }

    @IsTest
    private static void updateTest() {
        // Multiple of 4 as there are 4 test cases.
        Integer numberOfAccounts = 4;
        Integer firstQuarter = Integer.valueOf(numberOfAccounts*0.25);
        Integer secondQuarter = Integer.valueOf(numberOfAccounts*0.5);
        Integer thirdQuarter = Integer.valueOf(numberOfAccounts*0.75);
        List<Account> accounts = AccountTestDataFactory.createAccounts(numberOfAccounts);
        for(Integer i = 0; i < firstQuarter; i++) {
            accounts[i].AnnualRevenue = null;
        }
        for(Integer i = firstQuarter; i < secondQuarter; i++) {
            accounts[i].AnnualRevenue = 200000;
        }
        for(Integer i = secondQuarter; i < thirdQuarter; i++) {
            accounts[i].AnnualRevenue = 600000;
        }
        for(Integer i = thirdQuarter; i < numberOfAccounts; i++) {
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

}