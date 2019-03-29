public with sharing class ParentAccountRatingUpdate implements Callable, Queueable {

    private List<Account> records;

    public ParentAccountRatingUpdate() {}

	public ParentAccountRatingUpdate(List<Account> records) {
		this.records = records;
	}

    public void execute(QueueableContext context) {
        update records;
    }

    public static String updateParentAccountRating(List<Account> records, Map<Id, Account> oldRecords) {
        Map<Id, Account> parentAccounts = getParentAccounts(records);
        Map<Id, Account> parentAccountsToUpdate = setRatingFromChild(records, oldRecords, parentAccounts);
        if (parentAccountsToUpdate == null || parentAccountsToUpdate.isEmpty()) {
            return 'Method executed: updateParentAccountRating, no job enqueued as there is no parent account to update.';
        }
        else {
            ID jobID = System.enqueueJob(new ParentAccountRatingUpdate(parentAccountsToUpdate.values()));
            return 'Job enqueued: updateParentAccountRatingQueueable with ID: ' + jobID;
        }
    }

    private static Map<Id, Account> getParentAccounts(List<Account> records) {
        Set<String> parentAccountsId = new Set<String> ();
        for (Account acc : records) {
            if (acc.ParentId != null) {
                parentAccountsId.add(acc.ParentId);
            }
        }
        Map<Id, Account> parentAccounts = new Map<Id, Account>([SELECT Id, Rating FROM Account WHERE Id IN :parentAccountsId]);
        return parentAccounts.isEmpty() ? null : parentAccounts;
    }

    private static Map<Id, Account> setRatingFromChild(List<Account> records, Map<Id, Account> oldRecords, Map<Id, Account> parentAccounts) {
        Map<Id, Account> parentAccountsToUpdate = new Map<Id, Account> ();
        for (Account acc : records) {
            if ((acc.ParentId != null && parentAccounts != null && !parentAccounts.isEmpty()
                && parentAccounts.get(acc.ParentId) != null && parentAccounts.get(acc.ParentId).Rating == null)
                && (oldRecords == null || acc.Rating != oldRecords.get(acc.Id).Rating)) {
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