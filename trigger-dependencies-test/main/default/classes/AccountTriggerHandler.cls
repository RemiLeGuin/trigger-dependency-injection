public with sharing class AccountTriggerHandler implements Callable {
    
    private String updateRating(List<Account> records, Map<Id, Account> oldRecords) {
        for (Account acc : records) {
            if (oldRecords == null || acc.AnnualRevenue != oldRecords.get(acc.Id).AnnualRevenue) {
                if (acc.AnnualRevenue > 1000000) {
                    acc.Rating = 'Hot';
                } else if (acc.AnnualRevenue > 500000) {
                    acc.Rating = 'Warm';
                } else if (acc.AnnualRevenue > 0) {
                    acc.Rating = 'Cold';
                } else {
                    acc.Rating = null;
                }
            }
        }
        return 'Method executed: updateRating';
    }
    
    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'updateRating' {
                return this.updateRating((List<Account>)args.get('records'),
                                         (Map<Id, Account>)args.get('oldRecords'));
            } when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}
    
}