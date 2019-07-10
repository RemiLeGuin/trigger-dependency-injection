@IsTest
private class AccountRatingUpdateTestNoDml {
    
    @IsTest
    private static void updateAccountRatingTestNull() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithAnnualRevenue(null, 200);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };

		Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
        callableClass.call('updateAccountRating', parameters);
		Test.stopTest();

        System.assertEquals(null, accounts[0].Rating, 'Rating changed while Annual Revenue is null');
    }

    @IsTest
    private static void updateAccountRatingTestCold() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithAnnualRevenue(10000, 200);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };

		Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
        callableClass.call('updateAccountRating', parameters);
		Test.stopTest();

        System.assertEquals('Cold', accounts[0].Rating,
                            'When Annual Revenue is lower than 500,000 euros, Rating should set to \'Cold\'');
    }

    @IsTest
    private static void updateAccountRatingTestWarm() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithAnnualRevenue(800000, 200);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };

		Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
        callableClass.call('updateAccountRating', parameters);
		Test.stopTest();

        System.assertEquals('Warm', accounts[0].Rating,
                            'When Annual Revenue is between 500,000 and 1,000,000 euros, Rating should set to \'Warm\'');
    }

    @IsTest
    private static void updateAccountRatingTestHot() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithAnnualRevenue(1500000, 200);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };

		Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
        callableClass.call('updateAccountRating', parameters);
		Test.stopTest();

        System.assertEquals('Hot', accounts[0].Rating,
                            'When Annual Revenue is above 1,000,000 euros, Rating should set to \'Hot\'');
    }

    @IsTest
    private static void updateAccountDescriptionTestNull() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithRating(null, 200);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };

		Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
        callableClass.call('updateAccountDescription', parameters);
		Test.stopTest();

        System.assertEquals(null, accounts[0].Description, 'Description changed while Annual Revenue is null');
    }

    @IsTest
    private static void updateAccountDescriptionTestCold() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithRating('Cold', 200);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };

		Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
        callableClass.call('updateAccountDescription', parameters);
		Test.stopTest();

        System.assertEquals('Account is becoming Cold!', accounts[0].Description,
                            'Description shall notify changed Rating to \'Cold\'');
    }

    @IsTest
    private static void updateAccountDescriptionTestWarm() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithRating('Warm', 200);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };

		Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
        callableClass.call('updateAccountDescription', parameters);
		Test.stopTest();

        System.assertEquals('Account is becoming Warm!', accounts[0].Description,
                            'Description shall notify changed Rating to \'Warm\'');
    }

    @IsTest
    private static void updateAccountDescriptionTestHot() {
        List<Account> accounts = AccountTestDataFactoryNoDml.getAccountsWithRating('Hot', 200);
        Map<String, Object> parameters = new Map<String, Object> {
            'parameter1' => accounts,
            'parameter2' => null
        };

		Test.startTest();
        Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
        callableClass.call('updateAccountDescription', parameters);
		Test.stopTest();

        System.assertEquals('Account is becoming Hot!', accounts[0].Description,
                            'Description shall notify changed Rating to \'Hot\'');
    }

	@IsTest
	private static void testNonImplementedMethod() {
        String exceptionThrown;

		Test.startTest();
        try {
            Callable callableClass = (Callable)Type.forName('AccountRatingUpdate').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
		Test.stopTest();

        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
	}

}