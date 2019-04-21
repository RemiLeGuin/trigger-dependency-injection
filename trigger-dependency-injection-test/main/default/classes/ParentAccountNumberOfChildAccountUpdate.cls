public with sharing class ParentAccountNumberOfChildAccountUpdate implements Queueable {

	private List<Account> accounts;

    public ParentAccountNumberOfChildAccountUpdate() {}

	public ParentAccountNumberOfChildAccountUpdate(List<Account> accounts) {
		this.accounts = accounts;
	}

	public void execute(QueueableContext context) {
		update accounts;
	}

	public static String updateParentAccountNumberOfChildAccount(List<Account> accounts, Map<Id, Account> oldAccounts) {
		Set<Id> parentAccountsIdsToUpdate = getParentAccountsIdsToUpdate(accounts, oldAccounts);
		Map<Id, Account> parentAccountsToUpdate = parentAccountsIdsToUpdate.isEmpty() ?
												  null : setParentAccountsNumberOfChildAccount(parentAccountsIdsToUpdate);
		if ((Test.isRunningTest() || System.isQueueable()) && parentAccountsToUpdate != null && !parentAccountsToUpdate.isEmpty()) {
			update parentAccountsToUpdate.values();
		}
		else if (parentAccountsToUpdate != null && !parentAccountsToUpdate.isEmpty()) {
			System.enqueueJob(new ParentAccountNumberOfChildAccountUpdate(parentAccountsToUpdate.values()));
		}
        return 'Method executed: ParentAccountNumberOfChildAccountUpdate.updateParentAccountNumberOfChildAccount';
	}

	private static Set<Id> getParentAccountsIdsToUpdate(List<Account> accounts, Map<Id, Account> oldAccounts) {
		Set<Id> parentAccountsIdsToUpdate = new Set<Id> ();
		if (accounts != null && !accounts.isEmpty() && oldAccounts != null && !oldAccounts.isEmpty()) {
			for (Account child : accounts) {
				if (oldAccounts.get(child.Id) != null && child.ParentId != oldAccounts.get(child.Id).ParentId) {
					parentAccountsIdsToUpdate.add(child.ParentId);
					parentAccountsIdsToUpdate.add(oldAccounts.get(child.Id).ParentId);
				}
			}
		}
		else if (accounts != null && !accounts.isEmpty()) {
			for (Account child : accounts) {
				parentAccountsIdsToUpdate.add(child.ParentId);
			}
		}
		else if (oldAccounts != null && !oldAccounts.isEmpty()) {
			for (Account child : oldAccounts.values()) {
				parentAccountsIdsToUpdate.add(child.ParentId);
			}
		}
		parentAccountsIdsToUpdate.remove(null);
		return parentAccountsIdsToUpdate;
	}

	private static Map<Id, Account> setParentAccountsNumberOfChildAccount(Set<Id> parentAccountsIdsToUpdate) {
		Map<Id, Account> parentAccountsToUpdate = new Map<Id, Account> ();
		for (Id accountId : parentAccountsIdsToUpdate) {
			parentAccountsToUpdate.put(accountId, new Account(Id = accountId, NumberOfChildAccount__c = 0));
		}
		for (Account acc : [SELECT ParentId FROM Account WHERE ParentId IN :parentAccountsIdsToUpdate]) {
			parentAccountsToUpdate.get(acc.ParentId).NumberOfChildAccount__c++;
		}
		return parentAccountsToUpdate;
	}
    
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'updateParentAccountNumberOfChildAccount' {
                return updateParentAccountNumberOfChildAccount((List<Account>)arguments.get('parameter1'),
                                                               (Map<Id, Account>)arguments.get('parameter2'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}
    
}