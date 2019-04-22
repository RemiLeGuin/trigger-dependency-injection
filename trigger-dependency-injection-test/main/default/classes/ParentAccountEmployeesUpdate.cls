public with sharing class ParentAccountEmployeesUpdate implements Callable, Queueable {

	private List<Account> accounts;

    public ParentAccountEmployeesUpdate() {}

	public ParentAccountEmployeesUpdate(List<Account> accounts) {
		this.accounts = accounts;
	}

	public void execute(QueueableContext context) {
		update accounts;
	}

	public static String updateParentAccountEmployees(List<Account> accounts, Map<Id, Account> oldAccounts) {
		Set<Id> parentAccountsIdsToUpdate = getParentAccountsIdsToUpdate(accounts, oldAccounts);
		Map<Id, Account> parentAccountsToUpdate = parentAccountsIdsToUpdate.isEmpty() ?
												  null : setParentAccountsEmployees(parentAccountsIdsToUpdate);
		if (parentAccountsToUpdate == null || parentAccountsToUpdate.isEmpty()) {
            return 'Method executed: ParentAccountEmployeesUpdate.updateParentAccountEmployees, no job enqueued as there is no parent account to update.';
        }
        else if ((Test.isRunningTest() || System.isQueueable() || System.isFuture() || System.isBatch())
                 && parentAccountsToUpdate != null && !parentAccountsToUpdate.isEmpty()) {
            update parentAccountsToUpdate.values();
            return 'Method executed: ParentAccountEmployeesUpdate.updateParentAccountEmployees, no job enqueued as this is already asynchronous or test class.';
        }
        else {
            ID jobID = System.enqueueJob(new ParentAccountEmployeesUpdate(parentAccountsToUpdate.values()));
            return 'Job enqueued: ParentAccountEmployeesUpdate.updateParentAccountEmployees with ID: ' + jobID;
        }
	}

	private static Set<Id> getParentAccountsIdsToUpdate(List<Account> accounts, Map<Id, Account> oldAccounts) {
		Set<Id> parentAccountsIdsToUpdate = new Set<Id> ();
		if (accounts != null && !accounts.isEmpty() && oldAccounts != null && !oldAccounts.isEmpty()) {
			for (Account child : accounts) {
				if (oldAccounts.get(child.Id) != null && (child.ParentId != oldAccounts.get(child.Id).ParentId
					|| child.NumberOfEmployees != oldAccounts.get(child.Id).NumberOfEmployees)) {
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

	private static Map<Id, Account> setParentAccountsEmployees(Set<Id> parentAccountsIdsToUpdate) {
		Map<Id, Account> parentAccountsToUpdate = new Map<Id, Account> ();
		for (Id accountId : parentAccountsIdsToUpdate) {
			parentAccountsToUpdate.put(accountId, new Account(Id = accountId, NumberOfEmployees = null));
		}
		for (Account acc : [SELECT ParentId, NumberOfEmployees FROM Account WHERE ParentId IN :parentAccountsIdsToUpdate]) {
			if (parentAccountsToUpdate.get(acc.ParentId).NumberOfEmployees != null && acc.NumberOfEmployees != null) {
				parentAccountsToUpdate.get(acc.ParentId).NumberOfEmployees += acc.NumberOfEmployees;
			}
			else if (parentAccountsToUpdate.get(acc.ParentId).NumberOfEmployees == null && acc.NumberOfEmployees != null) {
				parentAccountsToUpdate.get(acc.ParentId).NumberOfEmployees = acc.NumberOfEmployees;
			}
		}
		return parentAccountsToUpdate;
	}
    
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'updateParentAccountEmployees' {
                return updateParentAccountEmployees((List<Account>)arguments.get('parameter1'),
													(Map<Id, Account>)arguments.get('parameter2'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}
    
}