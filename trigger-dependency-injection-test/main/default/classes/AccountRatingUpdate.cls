public with sharing class AccountRatingUpdate implements Callable {
    
    public String updateAccountRating(List<Account> accounts, Map<Id, Account> oldAccounts) {
        for (Account acc : accounts) {
            if (oldAccounts == null || acc.AnnualRevenue != oldAccounts.get(acc.Id).AnnualRevenue) {
                if (acc.AnnualRevenue > 1000000) {
                    acc.Rating = 'Hot';
                }
                else if (acc.AnnualRevenue > 500000) {
                    acc.Rating = 'Warm';
                }
                else if (acc.AnnualRevenue > 0) {
                    acc.Rating = 'Cold';
                }
                else {
                    acc.Rating = null;
                }
            }
        }
        return 'Method executed: AccountRatingUpdate.updateAccountRating';
    }

    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'updateAccountRating' {
                return this.updateAccountRating((List<Account>)arguments.get('records'),
                                                (Map<Id, Account>)arguments.get('oldRecords'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}
    
}