/**
 * @author Rémi Le Guin
 * @date 09/04/2019
 * @description Trigger handlers caller breaking up the dependencies between triggers and classes called by the triggers (handlers, service managers...). The handler classes shall implement the System.Callable interface provided by Salesforce.
 */
global with sharing class TDI_Caller {
    
    private static String bypassedMethods;
    public static Boolean byPassAllTriggers = false;
    private static List<TDI_HandlerMethod__mdt> methods;
    private static String currentObject;
    private static String currentOperation;

    static {
        bypassedMethods = [SELECT TDI_BypassedMethods__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].TDI_BypassedMethods__c;
    }

    /**
     * @description Get the custom metadata containing information on the handlers and execute them.
     * @param callingTrigger Name of the trigger calling the method.
     * @param moment When the method shall be called: before or after.
     * @param operation DML operation for which the method shall be called: insert, update, delete or undelete.
     */
    global static void callHandlers(String callingTrigger, String moment, String operation) {
        if (byPassAllTriggers == false) {
            if (methods == null || callingTrigger != currentObject || operation != currentOperation) {
                methods = [SELECT TDI_ClassName__c, DeveloperName, TDI_Moment__c, TDI_IndexOfExecution__c,
                                  TDI_MethodName__c, TDI_Parameter1__c, TDI_Parameter2__c
                           FROM TDI_HandlerMethod__mdt
                           WHERE TDI_Active__c = true AND TDI_CallingTrigger__c = :callingTrigger AND TDI_Operation__c = :operation
                           ORDER BY TDI_IndexOfExecution__c ASC];
                currentObject = callingTrigger;
                currentOperation = operation;
            }
            // Stores the handler classes which already may have been instanciated.
            Map<String, Callable> instanciatedClasses = new Map<String, Callable> ();
            for (TDI_HandlerMethod__mdt method : methods) {
                if (method.TDI_Moment__c == moment && (String.isBlank(bypassedMethods) || !bypassedMethods.contains(method.DeveloperName))) {
                    Callable callableClass = instanciateHandler(method.TDI_ClassName__c, instanciatedClasses);
                    Map<String, Object> parameters = setParameters(method.TDI_Parameter1__c, method.TDI_Parameter2__c);
                    System.debug(callableClass.call(method.TDI_MethodName__c, parameters));
                }
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

    /**
     * @description Allows to bypass all handler methods registered in the TDI_HandlerMethod__mdt custom metadata except for those informed.
     * @param methodsToExecute API name of the custom metadatas mentionning the handler methods to execute.
     * @param callingTrigger Object's API name if the bypass shall only concern handler methods called from specific triggers.
     * @return A list of bypassed handler methods in a string semi-colon separated.
     */
    global static String bypassAllExcept(List<String> methodsToExecute, String callingTrigger) {
        List<TDI_HandlerMethod__mdt> methods;
        if (String.isBlank(callingTrigger)) {
            methods = [SELECT DeveloperName FROM TDI_HandlerMethod__mdt];
        }
        else {
            methods = [SELECT DeveloperName FROM TDI_HandlerMethod__mdt WHERE TDI_CallingTrigger__c = :callingTrigger];
        }
        List<String> bypassedMethodsSet = new List<String> ();
        for (TDI_HandlerMethod__mdt method : methods) {
            if (!methodsToExecute.contains(method.DeveloperName)) {
                bypassedMethodsSet.add(method.DeveloperName);
            }
        }
        bypassedMethods = '';
        if (!bypassedMethodsSet.isEmpty()) {
            bypassedMethods = String.join(bypassedMethodsSet, ';');
        }
        return bypassedMethods;
    }
    
}