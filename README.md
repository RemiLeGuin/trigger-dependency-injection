# Trigger Dependencies design pattern

The [TriggerDependencies](https://github.com/RemiLeGuin/TriggerDependencies) repository contains a design pattern which breaks up the dependencies between triggers and classes called by the triggers (handlers, service managers...). It uses the [Callable interface](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_interface_System_Callable.htm) (Winter '19 release) to do so. Then, it allows to install and uninstall unlocked packages which use triggers as core code of an org without facing dependency issues.

The [TriggerDependencies](https://github.com/RemiLeGuin/TriggerDependencies) repository contains the core code as the design pattern.

The [TriggerDependenciesTest](https://github.com/RemiLeGuin/TriggerDependenciesTest) repository contains a trigger handler class and its corresponding custom metadata to relate it to the desired trigger. It is an example to illustrate that this package may be installed and uninstalled independently from the core package.

To know and understand the purpose of unlocked packages, please review the 'Unlocked Packages' topic of [the following Trailhead unit](https://trailhead.salesforce.com/content/learn/modules/package-development-readiness/assemble-an-effective-team).

To learn how to manipulate unlocked packages, please review [the following Trailhead module](https://trailhead.salesforce.com/content/learn/modules/unlocked-packages-for-customers).

## Step 1: Install the TriggerDependencies unlocked package in an org

Clone the [TriggerDependencies](https://github.com/RemiLeGuin/TriggerDependencies) repository to your local machine.

Connect to a default org.

Install the repo content as an unlocked package:
```
sfdx force:package:create --name "Trigger Dependencies" --description "Design pattern allowing to install and uninstall unlocked packages using triggers without dependencies." --packagetype Unlocked --path force-app --nonamespace --targetdevhubusername /*targeted org or username*/
```
```
sfdx force:package:version:create -p "Trigger Dependencies" -d force-app -k /*password*/ --wait 10 -v /*targeted org or username*/
```
```
sfdx force:package:install --wait 10 --publishwait 10 --package "Trigger Dependencies@0.1.0-1" -k /*password*/ -r -u /*targeted org or username*/
```

## Step 2: Create a generic trigger to handle all actions on a SObject

Create an 'Account' trigger and paste the following code in the default org:

```
trigger Account on Account (before insert, before update, before delete,
                            after insert, after update, after delete, after undelete) {
    
    Caller.callHandlers('Account');
    
}
```

## Step 3: Install the unlocked package to test a new functionnality that use the defined previous trigger

Clone the [TriggerDependenciesTest](https://github.com/RemiLeGuin/TriggerDependenciesTest) repository to your local machine

Connect to the default org used before

Install the repo content as an unlocked package:
```
sfdx force:package:create --name "Trigger Dependencies Test" --description "Test the Trigger Dependencies unlocked package." --packagetype Unlocked --path force-app --nonamespace --targetdevhubusername /*targeted org or username*/
```
```
sfdx force:package:version:create -p "Trigger Dependencies Test" -d force-app -k /*password*/ --wait 10 -v /*targeted org or username*/
```
```
sfdx force:package:install --wait 10 --publishwait 10 --package "Trigger Dependencies Test@0.1.0-1" -k /*password*/ -r -u /*targeted org or username*/
```
