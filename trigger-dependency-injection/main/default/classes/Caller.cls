/**
* @author Rémi Le Guin
* @date 09/04/2019
* @description Trigger handlers caller breaking up the dependencies between triggers and classes called by the triggers (handlers, service managers...). The handler classes shall implement the System.Callable interface provided by Salesforce.
*/
global without sharing class Caller {
    
    /**
    * @description Get the custom metadata containing information on the handlers and execute them.
    * @param callingTrigger Name of the trigger calling the method.
    */
    global static void callHandlers(String callingTrigger, String moment, String operation) {
        List<HandlerMethod__mdt> methods = [SELECT ClassName__c, IndexOfExecution__c, MethodName__c,
                                            Moment__c, Operation__c, Parameter1__c, Parameter2__c
                                            FROM HandlerMethod__mdt
                                            WHERE Active__c = true AND CallingTrigger__c = :callingTrigger
                                                  AND Moment__c = :moment AND Operation__c = :operation
                                            ORDER BY IndexOfExecution__c ASC];
        // Stores the handler classes which already may have been instanciated.
        Map<String, Callable> instanciatedClasses = new Map<String, Callable> ();
        for (HandlerMethod__mdt method : methods) {
            Callable callableClass = instanciateHandler(method, instanciatedClasses);
            Map<String, Object> parameters = setParameters(method);
            System.debug(callableClass.call(method.MethodName__c, parameters));
        }
    }
    
    /**
    * @description Set the chosen parameters from the custom metadata to pass to the method to be called.
    * @param method Custom metadata containing information about the method to execute.
    * @return A map with parameter names and their value as an object.
    */
    private static Map<String, Object> setParameters(HandlerMethod__mdt method) {
        Map<String, Object> parameters = new Map<String, Object> ();
        switch on method.Parameter1__c {
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
        switch on method.Parameter2__c {
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
    * @param method Custom metadata containing information about the method to execute.
    * @return Instanciated class implementing Callable interface.
    */
    private static Callable instanciateHandler(HandlerMethod__mdt method, Map<String, Callable> instanciatedClasses) {
        if (instanciatedClasses.isEmpty() || instanciatedClasses.get(method.ClassName__c) == null) {
            Callable callableClass = (Callable)Type.forName(method.ClassName__c).newInstance();
            // Stores the instanciated handler class in case it is called again later.
            instanciatedClasses.put(method.ClassName__c, callableClass);
            return callableClass;
        }
        else {
            // If the class has already been instanciated, get it from the Map where it has previously been stored.
            return instanciatedClasses.get(method.ClassName__c);
        }
    }
    
}