# Trigger Dependency Injection (TDI)

The [TriggerDependencyInjection](https://github.com/RemiLeGuin/TriggerDependencyInjection) repository introduces a design pattern for Salesforce which breaks up the dependencies between APEX triggers and classes called by the triggers (handlers, service managers...). It uses the [Callable interface](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_interface_System_Callable.htm) (Winter '19 release) to do so. Then, it allows to install and uninstall unlocked packages which use triggers as core code of an org without facing dependency issues.

The [TriggerDependencyInjection](https://github.com/RemiLeGuin/TriggerDependencyInjection) repository contains 2 directories:
-   **trigger-dependency-injection**: the core code illustrating the design pattern,
-   **trigger-dependency-injection-test**: a trigger handler class and its corresponding custom metadata to relate it to the desired trigger. It is an example to illustrate that this package may be installed and uninstalled independently from the core package.

The test directory will be the second unlocked package to be installed because it depends on the first one. This relation is set later in the sfdx-project.json file.

To know and understand the purpose of unlocked packages, please review the 'Unlocked Packages' topic of [the following Trailhead unit](https://trailhead.salesforce.com/content/learn/modules/package-development-readiness/assemble-an-effective-team).

To learn how to manipulate unlocked packages, please review [the following Trailhead module](https://trailhead.salesforce.com/content/learn/modules/unlocked-packages-for-customers).

## Step 1: Install the trigger-dependency-injection directory as an unlocked package in an org

-   Clone the [TriggerDependencyInjection](https://github.com/RemiLeGuin/TriggerDependencyInjection) repository to your local machine.
-   Connect to a default org (Sandbox, Trailhead Playground, Scratch Org...) with Dev Hub and Unlocked Packages enabled.
-   Install the trigger-dependency-injection directory as an unlocked package:
```
sfdx force:package:create --name "Trigger Dependency Injection (TDI)" --description "Design pattern allowing to install and uninstall unlocked packages using triggers without dependencies." --packagetype Unlocked --path trigger-dependency-injection --nonamespace --targetdevhubusername /*targeted org or username*/
```
```
sfdx force:package:version:create --package "Trigger Dependency Injection (TDI)" --path trigger-dependency-injection --installationkey /*password*/ --wait 10 --targetdevhubusername /*targeted org or username*/
```
```
sfdx force:package:install --wait 10 --publishwait 10 --package "Trigger Dependency Injection (TDI)@0.1.0-1" --installationkey /*password*/ --noprompt --targetusername /*targeted org or username*/
```

## Step 2: Create a generic trigger to handle all actions on a SObject

-   Create an 'Account' trigger and paste the following code in the default org:

```
trigger Account on Account (before insert, before update, before delete,
                            after insert, after update, after delete, after undelete) {
  
  Caller.callHandlers('Account');
  
}
```

## Step 3: Install the trigger-dependency-injection-test directory as an unlocked package to test a new functionnality that uses the defined previous trigger

-   Install the trigger-dependency-injection-test directory as an unlocked package:
```
sfdx force:package:create --name "Trigger Dependency Injection (TDI) Test" --description "Test package for the Trigger Dependency Injection (TDI) unlocked package." --packagetype Unlocked --path trigger-dependency-injection-test --nonamespace --targetdevhubusername /*targeted org or username*/
```
-   In sfdx-project.json, add the dependency of the second package to the first one:
```
{
  "path": "trigger-dependency-injection-test",
  "package": "Trigger Dependency Injection (TDI) Test",
  "versionName": "ver 0.1",
  "versionNumber": "0.1.0.NEXT",
  "default": false,
  "dependencies": [
    {
      "package": "Trigger Dependency Injection (TDI)",
      "versionNumber": "0.1.0.LATEST"
    }
  ]
}
```
Otherwise, you will not be able to install the second package containing a custom metadata which needs the custom metadata type in the first package.
-   Then, proceed with versioning and installing the second package:
```
sfdx force:package:version:create --package "Trigger Dependency Injection (TDI) Test" --path trigger-dependency-injection-test --installationkey /*password*/ --wait 10 --targetdevhubusername /*targeted org or username*/
```
```
sfdx force:package:install --wait 10 --publishwait 10 --package "Trigger Dependency Injection (TDI) Test@0.1.0-1" --installationkey /*password*/ --noprompt --targetusername /*targeted org or username*/
```

## Test it yourself!
> IMPORTANT: To test the functionality with a user other than 'System Administrator', do not forget to assign the permission sets to the desired users from other profiles with the following command lines after the packages installation:
```
sfdx force:user:permset:assign --permsetname TriggerDependencyInjection --onbehalfof /*username1@my.org, username2@my.org, username3@my.org ...*/
```
```
sfdx force:user:permset:assign --permsetname ManageAccountRating --onbehalfof /*username1@my.org, username2@my.org, username3@my.org ...*/
```
You will see both packages installed in the org in *Setup -> Installed Packages*. You can test the functionality that way:
-   Create an Account with a Annual Revenue set to 200000. Its rating is automatically set to 'Cold'. That is the purpose of the functionality.
-   Uninstall the second package: Trigger Dependency Injection (TDI) Test in *Setup -> Installed Packages*.
-   Create another Account with a Annual Revenue set to 200000. Its rating is not automatically set anymore. The functionality is properly removed (the APEX class and its corresponding custom metadata). Of course, the Account trigger remains in case of other use cases but you are free to include it the first or the second package.
