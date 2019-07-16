@IsTest
private class AccountDeleteTestNoDml {
    
    @IsTest
    private static void checkAccountRatingTestNull() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithRating(false, false, 200, null);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };
                    
        Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountDelete').newInstance();
        callableClass.call('checkAccountRating', parameters);
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages(), 'An error message is displayed forbidding deletion while accounts have no rating');
    }
    
    @IsTest
    private static void checkAccountRatingTestCold() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithRating(false, false, 200, 'Cold');
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };
                    
        Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountDelete').newInstance();
        callableClass.call('checkAccountRating', parameters);
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages(), 'An error message is displayed forbidding deletion while accounts are \'Cold\'');
    }
    
    @IsTest
    private static void checkAccountRatingTestWarm() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithRating(false, false, 200, 'Warm');
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };
                    
        Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountDelete').newInstance();
        callableClass.call('checkAccountRating', parameters);
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages(), 'An error message is displayed forbidding deletion while accounts are \'Warm\'');
    }
    
    @IsTest
    private static void checkAccountRatingTestHot() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithRating(false, false, 200, 'Hot');
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };
                    
        Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountDelete').newInstance();
        callableClass.call('checkAccountRating', parameters);
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(), 'No error message is displayed allowing deletion while accounts are \'Hot\'');
    }
    
    @IsTest
    private static void testNonImplementedMethod() {
        String exceptionThrown;
        
        Test.startTest();
        try {
            Callable callableClass = (Callable)Type.forName('AccountDelete').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
        Test.stopTest();
        
        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
    }
    
}