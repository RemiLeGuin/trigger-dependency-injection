public with sharing class ParentAccountIndustryUpdate implements Callable, Queueable {

    private List<Account> records;
    private Map<Id, Account> oldRecords;

    public ParentAccountIndustryUpdate() {}

	public ParentAccountIndustryUpdate(List<Account> records, Map<Id, Account> oldRecords) {
		this.records = records;
		this.oldRecords = oldRecords;
	}

    public static String updateParentAccountIndustryQueueable(List<Account> records, Map<Id, Account> oldRecords) {
		ID jobID = System.enqueueJob(new ParentAccountIndustryUpdate(records, oldRecords));
        return 'Job enqueued: updateParentAccountIndustryQueueable with ID: ' + jobID;
	}

    public void execute(QueueableContext context) {
        System.debug(updateParentAccountIndustry(records, oldRecords));
    }

    public static String updateParentAccountIndustry(List<Account> records, Map<Id, Account> oldRecords) {
        Map<Id, Account> parentAccounts = getParentAccounts(records, oldRecords);
        List<Account> parentAccountsToUpdate = new List<Account> ();
        parentAccountsToUpdate.addAll(updateIndustryFromChild(records, oldRecords, parentAccounts));
        update parentAccountsToUpdate;
        return 'Method executed: updateParentAccountIndustry';
    }

    private static Map<Id, Account> getParentAccounts(List<Account> records, Map<Id, Account> oldRecords) {
        Set<String> parentAccountsId = new Set<String> ();
        for (Account acc : records) {
            if (acc.ParentId != null) {
                parentAccountsId.add(acc.ParentId);
            }
        }
        return new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :parentAccountsId]);
    }

    private static List<Account> updateIndustryFromChild(List<Account> records, Map<Id, Account> oldRecords, Map<Id, Account> parentAccounts) {
        List<Account> parentAccountsToUpdate = new List<Account> ();
        for (Account acc : records) {
            if ((acc.ParentId != null && parentAccounts != null && parentAccounts.get(acc.ParentId).Industry == null)
                && (oldRecords == null || acc.Industry != oldRecords.get(acc.Id).Industry)) {
                Account parentAccount = parentAccounts.get(acc.ParentId);
                parentAccount.Industry = acc.Industry;
                parentAccountsToUpdate.add(parentAccount);
            }
        }
        return parentAccountsToUpdate;
    }

    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'updateParentAccountIndustry' {
                return updateParentAccountIndustry((List<Account>)arguments.get('records'),
                                                   (Map<Id, Account>)arguments.get('oldRecords'));
            }
            when 'updateParentAccountIndustryQueueable' {
                return updateParentAccountIndustryQueueable((List<Account>)arguments.get('records'),
                                                            (Map<Id, Account>)arguments.get('oldRecords'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}
    
}