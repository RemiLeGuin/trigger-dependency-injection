@IsTest
private class ParentAccountRatingUpdateTest {

    @TestSetup
    private static void accountDataSetup() {
        List<Account> parentAccounts = new List<Account>();
        for(Integer i=0; i < 240; i++) {
            parentAccounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0')));
        }
        insert parentAccounts;
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i < 240; i++) {
            accounts.add(new Account(Name = 'Test' + String.valueOf(i).leftPad(3, '0'), ParentId = parentAccounts[i].Id));
        }
        insert accounts;
    }

    @IsTest
    private static void updateTest() {
        List<Account> accounts = [SELECT Rating FROM Account WHERE ParentId != null ORDER BY Name ASC];
        for(Integer i=0; i < 60; i++) {
            accounts[i].Rating = null;
        }
        for(Integer i=60; i < 120; i++) {
            accounts[i].Rating = 'Cold';
        }
        for(Integer i=120; i < 180; i++) {
            accounts[i].Rating = 'Warm';
        }
        for(Integer i=180; i < 240; i++) {
            accounts[i].Rating = 'Hot';
        }

        Test.startTest();
        update accounts;
        Test.stopTest();

        accounts = [SELECT Rating FROM Account WHERE ParentId != null ORDER BY Name ASC];
        List<Account> parentAccounts = [SELECT Rating FROM Account WHERE ParentId = null ORDER BY Name ASC];
        System.assertEquals(null, accounts[0].Rating, 'Account Rating set while it shall not');
        System.assertEquals(null, parentAccounts[0].Rating, 'Parent account Rating set while it shall not');
        System.assertEquals('Cold', accounts[60].Rating, 'Account Rating wrong or not set');
        System.assertEquals('Cold', parentAccounts[60].Rating, 'Parent account Rating wrong or not set');
        System.assertEquals('Warm', accounts[120].Rating, 'Account Rating wrong or not set');
        System.assertEquals('Warm', parentAccounts[120].Rating, 'Parent account Rating wrong or not set');
        System.assertEquals('Hot', accounts[180].Rating, 'Account Rating wrong or not set');
        System.assertEquals('Hot', parentAccounts[180].Rating, 'Parent account Rating wrong or not set');
    }

}