# Trigger Dependency Injection (TDI)

The [TriggerDependencyInjection](https://github.com/RemiLeGuin/TriggerDependencyInjection) repository introduces a micro-framework for Salesforce which breaks up the dependencies between APEX triggers and classes called by the triggers (handlers, service managers...). It uses the [Callable interface](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_interface_System_Callable.htm) (Winter '19 release) to do so. Then, it allows to install and uninstall unlocked packages which use triggers as core code of an org without facing dependency issues.

The [TriggerDependencyInjection](https://github.com/RemiLeGuin/TriggerDependencyInjection) repository contains 2 directories:
-   **trigger-dependency-injection**: the micro-framework itself as the core code,
-   **trigger-dependency-injection-test**: a trigger handler class and its corresponding custom metadata to relate it to the desired trigger. It is an example to illustrate that this package may be installed and uninstalled independently from the core package.

The test directory will be the second unlocked package to be installed because it depends on the first one. This relation is set later in the sfdx-project.json file.

To know and understand the purpose of unlocked packages, please review the 'Unlocked Packages' topic of [the following Trailhead unit](https://trailhead.salesforce.com/content/learn/modules/package-development-readiness/assemble-an-effective-team).

To learn how to manipulate unlocked packages, please review [the following Trailhead module](https://trailhead.salesforce.com/content/learn/modules/unlocked-packages-for-customers).

## Step 1: Install the trigger-dependency-injection directory as an unlocked package in an org

-   [Follow this link for Sandboxes](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002VVdhQAG "https://test.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002VVdhQAG")
-   [Follow this link for Production environments, Developer Editions and Trailhead Playgrounds](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002VVdhQAG "https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002VVdhQAG")

## Step 2 (for demo purpose only): Create generic triggers to handle all actions on a SObject

-   Create triggers for each event and operation on the Account SObject:
    -   AccountBeforeInsert
    -   AccountAfterInsert
    -   AccountBeforeUpdate
    -   AccountAfterUpdate
    -   AccountBeforeDelete
    -   AccountAfterDelete
    -   AccountAfterUndelete
-   Call the 'callHandlers' method in the 'Caller' class changing the parameters accordingly. Example:

```
trigger AccountBeforeInsert on Account (before insert) {
    Caller.callHandlers('Account', 'before', 'insert');
}
```

-   You also may take the opportunity to check permission at object level in the trigger:

```
trigger AccountBeforeDelete on Account (before delete) {
    if (Schema.SObjectType.Account.isDeletable()) {
        Caller.callHandlers('Account', 'before', 'delete');
    }
    else {
        for (SObject record : Trigger.old) {
            record.addError('You are not allowed to delete accounts.');
        }
    }
}
```

## Step 3 (for demo purpose only): Install the trigger-dependency-injection-test directory as an unlocked package to test a new functionnality that uses the defined previous trigger

-   [Follow this link for Sandboxes](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002VVm2QAG "https://test.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002VVm2QAG")
-   [Follow this link for Production environments, Developer Editions and Trailhead Playgrounds](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002VVm2QAG "https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002VVm2QAG")

## Test it yourself!
> IMPORTANT: To test the functionality with a user other than 'System Administrator', do not forget to assign the permission sets to the desired users from other profiles.

You can see both packages installed in the org in *Setup &rightarrow; Installed Packages*. You can test the functionality that way:
-   Create an Account with a Annual Revenue set to 200000. Its rating is automatically set to 'Cold'. That is the purpose of the functionality.
-   Uninstall the second package: Trigger Dependency Injection (TDI) Test in *Setup &rightarrow; Installed Packages*.
-   Create another Account with a Annual Revenue set to 200000. Its rating is not automatically set anymore. The functionality is properly removed (the APEX class and its corresponding custom metadata). Of course, the Account trigger remains in case of other use cases but you are free to include it the first or the second package.

## Bypass Methods

With the first package, a "BypassedMethods__c" field has been created on the "User" object. A "CallerMockMockingMethod" picklist value already exists, corresponding to a test method covering the "Caller" class from the core package.
If you want to bypass methods for specific users, set the custom metadata's API names as picklist values. For instance, according to the test package:
- CheckAccountRatingDelete
- UpdateAccountDescriptionUpdate
- UpdateAccountRatingInsert
- UpdateAccountRatingUpdate
- UpdateParentAccountEmployeesDelete
- UpdateParentAccountEmployeesInsert
- UpdateParentAccountEmployeesUndelete
- UpdateParentAccountEmployeesUpdate
- UpdateParentAccountRatingInsert
- UpdateParentAccountRatingUndelete
- UpdateParentAccountRatingUpdate