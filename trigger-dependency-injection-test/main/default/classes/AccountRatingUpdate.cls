public with sharing class AccountRatingUpdate implements Callable {
    
    public String updateAccountRating(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.AnnualRevenue > 1000000) {
                acc.Rating = 'Hot';
            }
            else if (acc.AnnualRevenue > 500000) {
                acc.Rating = 'Warm';
            }
            else if (acc.AnnualRevenue > 0) {
                acc.Rating = 'Cold';
            }
        }
        return 'Method executed: AccountRatingUpdate.updateAccountRating';
    }
    
    public static String updateAccountDescription(List<Account> accounts) {
        for (Account acc : accounts) {
            acc.Description = acc.Rating == null ? null : 'Account is becoming ' + acc.Rating + '!';
        }
        return 'Method executed: AccountRatingUpdate.updateAccountDescription';
    }
    
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'updateAccountRating' {
                return this.updateAccountRating((List<Account>)arguments.get('parameter1'));
            }
            when 'updateAccountDescription' {
                return updateAccountDescription((List<Account>)arguments.get('parameter1'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}
    
}