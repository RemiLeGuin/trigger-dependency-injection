@IsTest
private class ParentAccountRatingUpdateTest {

    @IsTest
    private static void updateParentAccountRatingInsertTest() {
        Integer numberOfAccounts = 201;
        Account grandParentAccount = AccountTestDataFactory.getGrandParentAccounts(true, false, true, 1)[0];
        List<Account> parentAccounts = AccountTestDataFactory.getParentAccounts(true, false, true, numberOfAccounts);
        List<Account> accountsToTest = AccountTestDataFactory.getAccountsWithRating(false, false, false, numberOfAccounts, 'Hot');
        for (Integer i = 0; i < numberOfAccounts; i++) {
            grandParentAccount.Rating = 'Cold';
            parentAccounts[i].ParentId = grandParentAccount.Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
        }
        TDI_Caller.byPassAllTriggers = true;
        update grandParentAccount;
        update parentAccounts;
        TDI_Caller.byPassAllTriggers = false;
        
        Test.startTest();
        TDI_Caller.bypassAllExcept(new List<String> { 'UpdateParentAccountRatingInsert', 'UpdateParentAccountRatingUpdate' }, 'Account');
        insert accountsToTest;
        Test.stopTest();
        
        parentAccounts = [SELECT Id, Rating FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
        for (Integer i = 0; i < numberOfAccounts; i++) {
            System.assertEquals('Hot', parentAccounts[i].Rating, 'Rating has not been set on parent account');
        }
        grandParentAccount = [SELECT Id, Rating FROM Account WHERE Name LIKE 'GrandParent%' LIMIT 1];
        System.assertEquals('Cold', grandParentAccount.Rating, 'Rating has been changed on grandparent account while it already had a rating');
    }

    @IsTest
    private static void updateParentAccountRatingUpdateTest() {
        Integer numberOfAccounts = 201;
        Account grandParentAccount = AccountTestDataFactory.getGrandParentAccounts(true, false, true, 1)[0];
        List<Account> parentAccounts = AccountTestDataFactory.getParentAccounts(true, false, true, numberOfAccounts);
        List<Account> accountsToTest = AccountTestDataFactory.getAccountsWithRating(true, false, true, numberOfAccounts, 'Cold');
        for (Integer i = 0; i < numberOfAccounts; i++) {
            parentAccounts[i].ParentId = grandParentAccount.Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
        }
        TDI_Caller.byPassAllTriggers = true;
        update parentAccounts;
        update accountsToTest;
        TDI_Caller.byPassAllTriggers = false;
        for (Integer i = 0; i < numberOfAccounts; i++) {
            accountsToTest[i].Rating = 'Warm';
        }
        
        Test.startTest();
        TDI_Caller.bypassAllExcept(new List<String> { 'UpdateParentAccountRatingUpdate' }, 'Account');
        update accountsToTest;
        Test.stopTest();
        
        parentAccounts = [SELECT Id, Rating FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
        for (Integer i = 0; i < numberOfAccounts; i++) {
            System.assertEquals('Warm', parentAccounts[i].Rating, 'Rating has not been set on parent account');
        }
        grandParentAccount = [SELECT Id, Rating FROM Account WHERE Name LIKE 'GrandParent%' LIMIT 1];
        System.assertEquals('Warm', grandParentAccount.Rating, 'Rating has not been set on grandparent account');
    }

    @IsTest
    private static void updateParentAccountRatingUndeleteTest() {
        Integer numberOfAccounts = 201;
        Account grandParentAccount = AccountTestDataFactory.getGrandParentAccounts(true, false, true, 1)[0];
        List<Account> parentAccounts = AccountTestDataFactory.getParentAccounts(true, false, true, numberOfAccounts);
        List<Account> accountsToTest = AccountTestDataFactory.getAccountsWithRating(true, false, true, numberOfAccounts, 'Cold');
        for (Integer i = 0; i < numberOfAccounts; i++) {
            parentAccounts[i].ParentId = grandParentAccount.Id;
            accountsToTest[i].ParentId = parentAccounts[i].Id;
        }
        TDI_Caller.byPassAllTriggers = true;
        update accountsToTest;
        delete accountsToTest;
        for (Integer i = 0; i < numberOfAccounts; i++) {
            parentAccounts[i].Rating = null;
        }
        update parentAccounts;
        TDI_Caller.byPassAllTriggers = false;

        Test.startTest();
        TDI_Caller.bypassAllExcept(new List<String> { 'UpdateParentAccountRatingUndelete', 'UpdateParentAccountRatingUpdate' }, 'Account');
        undelete accountsToTest;
        Test.stopTest();

        parentAccounts = [SELECT Id, Rating FROM Account WHERE Name LIKE 'Parent%' ORDER BY Name ASC];
        for (Integer i = 0; i < numberOfAccounts; i++) {
            System.assertEquals('Cold', parentAccounts[i].Rating, 'Rating has not been set on parent account');
        }
        grandParentAccount = [SELECT Id, Rating FROM Account WHERE Name LIKE 'GrandParent%' LIMIT 1];
        System.assertEquals('Cold', grandParentAccount.Rating, 'Rating has not been set on grandparent account');
    }

    @IsTest
    private static void testNonImplementedMethod() {
        String exceptionThrown;
        
        Test.startTest();
        try {
            Callable callableClass = (Callable)Type.forName('ParentAccountRatingUpdate').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
        Test.stopTest();
        
        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
    }

}