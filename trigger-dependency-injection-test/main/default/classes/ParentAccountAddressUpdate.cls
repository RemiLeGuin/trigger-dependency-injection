public with sharing class ParentAccountAddressUpdate implements Callable, Queueable {

    private List<Account> records;
    private Map<Id, Account> oldRecords;
    private static Map<Id, Account> parentAccounts;

	public ParentAccountAddressUpdate(List<Account> records, Map<Id, Account> oldRecords) {
		this.records = records;
		this.oldRecords = oldRecords;
	}

    public static String updateParentAccountAddressesQueueable(List<Account> records, Map<Id, Account> oldRecords) {
		System.enqueueJob(new ParentAccountAddressUpdate(records, oldRecords));
        return 'Job enqueued: updateParentAccountAddressesQueueable';
	}

    public void execute(QueueableContext context) {
        System.debug(updateParentAccountAddresses(records, oldRecords));
    }

    public static String updateParentAccountAddresses(List<Account> records, Map<Id, Account> oldRecords) {
        Map<Id, Account> parentAccounts = getParentAccounts(records, oldRecords);
        List<Account> parentAccountsToUpdate = new List<Account> ();
        parentAccountsToUpdate.addAll(updateBillingAddressFromChild(records, oldRecords, parentAccounts));
        parentAccountsToUpdate.addAll(updateShippingAddressFromChild(records, oldRecords, parentAccounts));
        update parentAccountsToUpdate;
        return 'Method executed: updateParentAccountAddresses';
    }

    private static Map<Id, Account> getParentAccounts(List<Account> records, Map<Id, Account> oldRecords) {
        Set<Id> parentAccountsId = new Set<Id> ();
        for (Account acc : records) {
            if (acc.ParentId == null) {
                parentAccountsId.add(acc.ParentId);
            }
        }
        return new Map<Id, Account>([SELECT Id, BillingAddress, ShippingAddress FROM Account WHERE Id IN :parentAccountsId]);
    }

    private static List<Account> updateBillingAddressFromChild(List<Account> records,
                                                               Map<Id, Account> oldRecords,
                                                               Map<Id, Account> parentAccounts) {
        List<Account> parentAccountsToUpdate = new List<Account> ();
        for (Account acc : records) {
            if ((acc.ParentId != null && parentAccounts.get(acc.ParentId).BillingAddress == null)
                && (oldRecords == null || acc.BillingAddress != oldRecords.get(acc.Id).BillingAddress)) {
                Account parentAccount = parentAccounts.get(acc.ParentId);
                parentAccount.BillingStreet = acc.BillingStreet;
                parentAccount.BillingPostalCode = acc.BillingPostalCode;
                parentAccount.BillingCity = acc.BillingCity;
                parentAccount.BillingState = acc.BillingState;
                parentAccount.BillingCountry = acc.BillingCountry;
                parentAccountsToUpdate.add(parentAccount);
            }
        }
        return parentAccountsToUpdate;
    }

    private static List<Account> updateShippingAddressFromChild(List<Account> records,
                                                                Map<Id, Account> oldRecords,
                                                                Map<Id, Account> parentAccounts) {
        List<Account> parentAccountsToUpdate = new List<Account> ();
        for (Account acc : records) {
            if ((acc.ParentId != null && parentAccounts.get(acc.ParentId).ShippingAddress == null)
                && (oldRecords == null || acc.ShippingAddress != oldRecords.get(acc.Id).ShippingAddress)) {
                Account parentAccount = parentAccounts.get(acc.ParentId);
                parentAccount.ShippingStreet = acc.ShippingStreet;
                parentAccount.ShippingPostalCode = acc.ShippingPostalCode;
                parentAccount.ShippingCity = acc.ShippingCity;
                parentAccount.ShippingState = acc.ShippingState;
                parentAccount.ShippingCountry = acc.ShippingCountry;
                parentAccountsToUpdate.add(parentAccount);
            }
        }
        return parentAccountsToUpdate;
    }

    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'updateParentAccountAddresses' {
                return updateParentAccountAddresses((List<Account>)arguments.get('records'),
                                                    (Map<Id, Account>)arguments.get('oldRecords'));
            }
            when 'updateParentAccountAddressesQueueable' {
                return updateParentAccountAddressesQueueable((List<Account>)arguments.get('records'),
                                                             (Map<Id, Account>)arguments.get('oldRecords'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}
    
}