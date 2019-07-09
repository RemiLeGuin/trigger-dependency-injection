/**
* @author Rémi Le Guin
* @date 09/04/2019
* @description Trigger handlers caller breaking up the dependencies between triggers and classes called by the triggers (handlers, service managers...). The handler classes shall implement the System.Callable interface provided by Salesforce.
*/
global without sharing class Caller {
    
    private static final String bypassedMethods;

    static {
        bypassedMethods = [SELECT BypassedMethods__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].BypassedMethods__c;
    }

    /**
    * @description Get the custom metadata containing information on the handlers and execute them.
    * @param callingTrigger Name of the trigger calling the method.
    * @param moment When the method shall be called: before or after.
    * @param operation DML operation for which the method shall be called: insert, update, delete or undelete.
    */
    global static void callHandlers(String callingTrigger, String moment, String operation) {
        List<HandlerMethod__mdt> methods = [SELECT ClassName__c, DeveloperName, IndexOfExecution__c,
                                                   MethodName__c, Parameter1__c, Parameter2__c
                                            FROM HandlerMethod__mdt
                                            WHERE Active__c = true AND CallingTrigger__c = :callingTrigger
                                                  AND Moment__c = :moment AND Operation__c = :operation
                                            ORDER BY IndexOfExecution__c ASC];
        // Stores the handler classes which already may have been instanciated.
        Map<String, Callable> instanciatedClasses = new Map<String, Callable> ();
        for (HandlerMethod__mdt method : methods) {
            if (String.isBlank(bypassedMethods) || !bypassedMethods.contains(method.DeveloperName)) {
                Callable callableClass = instanciateHandler(method.ClassName__c, instanciatedClasses);
                Map<String, Object> parameters = setParameters(method.Parameter1__c, method.Parameter2__c);
                System.debug(callableClass.call(method.MethodName__c, parameters));
            }
        }
    }
    
    /**
    * @description Set the chosen parameters from the custom metadata to pass to the method to be called.
    * @param parameter1 First parameter label to pass to the method.
    * @param parameter2 Second parameter label to pass to the method.
    * @return A map with parameter names and their value as an object.
    */
    @TestVisible
    private static Map<String, Object> setParameters(String parameter1, String parameter2) {
        Map<String, Object> parameters = new Map<String, Object> ();
        switch on parameter1 {
            when 'null' {
                parameters.put('parameter1', null);
            }
            when 'Trigger.new' {
                parameters.put('parameter1', Trigger.new);
            }
            when 'Trigger.newMap' {
                parameters.put('parameter1', Trigger.newMap);
            }
            when 'Trigger.old' {
                parameters.put('parameter1', Trigger.old);
            }
            when 'Trigger.oldMap' {
                parameters.put('parameter1', Trigger.oldMap);
            }
            when else {
                System.debug('No first parameter.');
            }
        }
        switch on parameter2 {
            when 'null' {
                parameters.put('parameter2', null);
            }
            when 'Trigger.new' {
                parameters.put('parameter2', Trigger.new);
            }
            when 'Trigger.newMap' {
                parameters.put('parameter2', Trigger.newMap);
            }
            when 'Trigger.old' {
                parameters.put('parameter2', Trigger.old);
            }
            when 'Trigger.oldMap' {
                parameters.put('parameter2', Trigger.oldMap);
            }
            when else {
                System.debug('No second parameter.');
            }
        }
        return parameters;
    }
    
    /**
    * @description Instanciates and stores a handler class or get it from the Map if it has previously been.
    * @param className Name of the class to be instanciated.
    * @param instanciatedClasses Map of already instanciated callable classes.
    * @return Instanciated class implementing Callable interface.
    */
    @TestVisible
    private static Callable instanciateHandler(String className, Map<String, Callable> instanciatedClasses) {
        if (instanciatedClasses.isEmpty() || instanciatedClasses.get(className) == null) {
            Callable callableClass = (Callable)Type.forName(className).newInstance();
            // Stores the instanciated handler class in case it is called again later.
            instanciatedClasses.put(className, callableClass);
            return callableClass;
        }
        else {
            // If the class has already been instanciated, get it from the Map where it has previously been stored.
            return instanciatedClasses.get(className);
        }
    }
    
}