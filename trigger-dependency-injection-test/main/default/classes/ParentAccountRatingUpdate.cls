public with sharing class ParentAccountRatingUpdate implements Callable, Queueable {

    private List<Account> accounts;

    public ParentAccountRatingUpdate() {}

	public ParentAccountRatingUpdate(List<Account> accounts) {
		this.accounts = accounts;
	}

    public void execute(QueueableContext context) {
        update accounts;
    }

    public static String updateParentAccountRating(List<Account> accounts, Map<Id, Account> oldAccounts) {
        Map<Id, Account> parentAccountsWithRatingNull = getParentAccountsWithRatingNull(accounts);
        Map<Id, Account> parentAccountsToUpdate = setRatingFromChild(accounts, oldAccounts, parentAccountsWithRatingNull);
        if (parentAccountsToUpdate == null || parentAccountsToUpdate.isEmpty()) {
            return 'Method executed: ParentAccountRatingUpdate.updateParentAccountRating, no job enqueued as there is no parent account to update.';
        }
        else if (Test.isRunningTest() && parentAccountsToUpdate != null && !parentAccountsToUpdate.isEmpty()) {
            update parentAccountsToUpdate.values();
            return 'Method executed: ParentAccountRatingUpdate.updateParentAccountRating, no job enqueued as this is a test class.';
        }
        else {
            ID jobID = System.enqueueJob(new ParentAccountRatingUpdate(parentAccountsToUpdate.values()));
            return 'Job enqueued: ParentAccountRatingUpdate.updateParentAccountRatingQueueable with ID: ' + jobID;
        }
    }

    private static Map<Id, Account> getParentAccountsWithRatingNull(List<Account> accounts) {
        Set<String> parentAccountsId = new Set<String> ();
        for (Account acc : accounts) {
            if (acc.ParentId != null) {
                parentAccountsId.add(acc.ParentId);
            }
        }
        Map<Id, Account> parentAccounts = new Map<Id, Account>([SELECT Id, Rating
                                                                FROM Account
                                                                WHERE Id IN :parentAccountsId AND Rating = null]);
        return parentAccounts.isEmpty() ? null : parentAccounts;
    }

    private static Map<Id, Account> setRatingFromChild(List<Account> accounts,
                                                       Map<Id, Account> oldAccounts,
                                                       Map<Id, Account> parentAccountsWithRatingNull) {
        Map<Id, Account> parentAccountsToUpdate = new Map<Id, Account> ();
        if (parentAccountsWithRatingNull != null && !parentAccountsWithRatingNull.isEmpty()) {
            for (Account acc : accounts) {
                if ((acc.ParentId != null && parentAccountsWithRatingNull.get(acc.ParentId) != null)
                    && (oldAccounts == null || acc.Rating != oldAccounts.get(acc.Id).Rating)) {
                    Account parentAccountWithRatingNull = parentAccountsWithRatingNull.get(acc.ParentId);
                    parentAccountWithRatingNull.Rating = acc.Rating;
                    parentAccountsToUpdate.put(acc.ParentId, parentAccountWithRatingNull);
                }
            }
        }
        return parentAccountsToUpdate.isEmpty() ? null : parentAccountsToUpdate;
    }

    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'updateParentAccountRating' {
                return updateParentAccountRating((List<Account>)arguments.get('records'),
                                                 (Map<Id, Account>)arguments.get('oldRecords'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}
    
}