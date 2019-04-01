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
        Map<Id, Account> parentAccounts = getParentAccounts(accounts);
        Map<Id, Account> parentAccountsToUpdate = setRatingFromChild(accounts, oldAccounts, parentAccounts);
        if (parentAccountsToUpdate == null || parentAccountsToUpdate.isEmpty()) {
            return 'Method executed: updateParentAccountRating, no job enqueued as there is no parent account to update.';
        }
        else if (Test.isRunningTest()) {
            update parentAccountsToUpdate.values();
            return 'Method executed: updateParentAccountRating, no job enqueued as this is a test class.';
        }
        else {
            ID jobID = System.enqueueJob(new ParentAccountRatingUpdate(parentAccountsToUpdate.values()));
            return 'Job enqueued: updateParentAccountRatingQueueable with ID: ' + jobID;
        }
    }

    private static Map<Id, Account> getParentAccounts(List<Account> accounts) {
        Set<String> parentAccountsId = new Set<String> ();
        for (Account acc : accounts) {
            if (acc.ParentId != null) {
                parentAccountsId.add(acc.ParentId);
            }
        }
        Map<Id, Account> parentAccounts = new Map<Id, Account>([SELECT Id, Rating FROM Account WHERE Id IN :parentAccountsId]);
        return parentAccounts.isEmpty() ? null : parentAccounts;
    }

    private static Map<Id, Account> setRatingFromChild(List<Account> accounts, Map<Id, Account> oldAccounts, Map<Id, Account> parentAccounts) {
        Map<Id, Account> parentAccountsToUpdate = new Map<Id, Account> ();
        for (Account acc : accounts) {
            if ((acc.ParentId != null && parentAccounts != null && !parentAccounts.isEmpty()
                && parentAccounts.get(acc.ParentId) != null && parentAccounts.get(acc.ParentId).Rating == null)
                && (oldAccounts == null || acc.Rating != oldAccounts.get(acc.Id).Rating)) {
                Account parentAccount = parentAccounts.get(acc.ParentId);
                parentAccount.Rating = acc.Rating;
                parentAccountsToUpdate.put(acc.ParentId, parentAccount);
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