@IsTest
private class AccountTriggerHandlerTest {

    @TestSetup
    private static void accountDataSetup() {
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i < 240; i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
        }
        insert accounts;
    }

    @IsTest
    private static void insertTest() {
        User testUser = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'System Administrator' LIMIT 1];
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i < 60; i++) {
            accounts.add(new Account(Name = 'TestInsert' + String.valueOf(i).leftPad(3, '0')));
        }
        for(Integer i=60; i < 120; i++) {
            accounts.add(new Account(Name = 'TestInsert' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 200000));
        }
        for(Integer i=120; i < 180; i++) {
            accounts.add(new Account(Name = 'TestInsert' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 600000));
        }
        for(Integer i=180; i < 240; i++) {
            accounts.add(new Account(Name = 'TestInsert' + String.valueOf(i).leftPad(3, '0'), AnnualRevenue = 1200000));
        }

        Test.startTest();
        System.runAs(testUser) {
            insert accounts;
        }
        Test.stopTest();

        accounts = [SELECT AnnualRevenue, Rating FROM Account WHERE Name LIKE 'TestInsert%' ORDER BY Name ASC];
        System.assertEquals(null, accounts[0].AnnualRevenue, 'No Account were created or Annual Revenue set while it shall not');
        System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
        System.assertEquals(200000, accounts[60].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Cold', accounts[60].Rating, 'Account Rating wrong or not set');
        System.assertEquals(600000, accounts[120].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Warm', accounts[120].Rating, 'Account Rating wrong or not set');
        System.assertEquals(1200000, accounts[180].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Hot', accounts[180].Rating, 'Account Rating wrong or not set');
    }

    @IsTest
    private static void updateTest() {
        User testUser = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'System Administrator' LIMIT 1];
        List<Account> accounts = [SELECT AnnualRevenue, Rating FROM Account ORDER BY Name ASC];
        for(Integer i=0; i < 60; i++) {
            accounts[i].AnnualRevenue = null;
        }
        for(Integer i=60; i < 120; i++) {
            accounts[i].AnnualRevenue = 200000;
        }
        for(Integer i=120; i < 180; i++) {
            accounts[i].AnnualRevenue = 600000;
        }
        for(Integer i=180; i < 240; i++) {
            accounts[i].AnnualRevenue = 1200000;
        }

        Test.startTest();
        System.runAs(testUser) {
            update accounts;
        }
        Test.stopTest();

        accounts = [SELECT AnnualRevenue, Rating FROM Account WHERE NOT(Name LIKE 'TestInsert%') ORDER BY Name ASC];
        System.assertEquals(null, accounts[0].AnnualRevenue, 'No Account were created or Annual Revenue set while it shall not');
        System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
        System.assertEquals(200000, accounts[60].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Cold', accounts[60].Rating, 'Account Rating wrong or not set');
        System.assertEquals(600000, accounts[120].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Warm', accounts[120].Rating, 'Account Rating wrong or not set');
        System.assertEquals(1200000, accounts[180].AnnualRevenue, 'No Account were created or wrong Annual Revenue');
        System.assertEquals('Hot', accounts[180].Rating, 'Account Rating wrong or not set');
    }

}
