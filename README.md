To know and understand the purpose of unlocked packages, please review the 'Unlocked Packages' topic of the following Trailhead unit:
https://trailhead.salesforce.com/content/learn/modules/package-development-readiness/assemble-an-effective-team
To learn how to manipulate unlocked packages, please review the following Trailhead module:
https://trailhead.salesforce.com/content/learn/modules/unlocked-packages-for-customers

Example of account trigger handler updating the account rating according to its annual revenue. The first part of the handler is the process we want to execute. The second part is the call implementation, similar in all handlers.

public with sharing class AccountTriggerHandler implements Callable {
    
    private String updateRating(List<Account> records, Map<Id, Account> oldRecords) {
        for (Account acc : records) {
            if (oldRecords == null || acc.AnnualRevenue != oldRecords.get(acc.Id).AnnualRevenue) {
                if (acc.AnnualRevenue > 1000000) {
                    acc.Rating = 'Hot';
                } else if (acc.AnnualRevenue > 500000) {
                    acc.Rating = 'Warm';
                } else {
                    acc.Rating = 'Cold';
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

For the account trigger to work, create an 'Account' trigger and call the 'Caller' class:
Caller.callHandlers('Account');

SFDX commands to create the unlocked package:

sfdx force:package:create --name "Trigger Dependencies" --description "Design pattern allowing to install and uninstall unlocked packages using triggers without dependencies." --packagetype Unlocked --path force-app --nonamespace --targetdevhubusername dependencies

sfdx force:package:version:create -p "Trigger Dependencies" -d force-app -k independent --wait 10 -v dependencies

sfdx force:package:install --wait 10 --publishwait 10 --package "Trigger Dependencies@0.1.0-1" -k independent -r -u dependencies