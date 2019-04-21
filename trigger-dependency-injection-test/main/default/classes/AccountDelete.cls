public with sharing class AccountDelete implements Callable {

    public static String checkAccountRating(List<Account> oldAccounts) {
        for (Account acc : oldAccounts) {
            if (acc.Rating == 'Hot') {
                acc.addError(Label.ErrorOnDeleteRating);
            }
        }
        return 'Method executed: AccountDelete.checkAccountRating';
    }

    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'checkAccountRating' {
                return checkAccountRating((List<Account>)arguments.get('parameter1'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}

}