/**
 * @author Rémi Le Guin
 * @date 09/04/2019
 * @description Trigger handlers caller breaking up the dependencies between triggers and classes called by the triggers (handlers, service managers...). The handler classes shall implement the System.Callable interface provided by Salesforce.
 */
public with sharing class Caller {

    // Stores the handler classes which already may have been instanciated.
    private static Map<String, Callable> instanciatedClasses = new Map<String, Callable> ();
    // The combination Trigger.new / Trigger oldMap works in most trigger cases.
    // In case of before insert operation, Trigger.newMap will not work as the records have no ID yet.
    // In case of before insert operation, Trigger.oldMap is automatically set to null.
    private static Map<String, Object> parameters = new Map<String, Object> {
        'records' => Trigger.new,
        'oldRecords' => Trigger.oldMap
    };
    
    /**
	 * @description Get the custom metadata containing information on the handlers and execute them.
	 * @param callingTrigger Name of the trigger calling the method.
	 */
    public static void callHandlers(String callingTrigger) {
        List<HandlerMethod__mdt> methods = [SELECT DeveloperName, ClassName__c, MethodName__c, Moments__c, Operations__c
                                            FROM HandlerMethod__mdt
                                            WHERE Active__c = true AND CallingTrigger__c = :callingTrigger
                                            ORDER BY IndexOfExecution__c ASC];
        for (HandlerMethod__mdt method : methods) {
            Callable callableClass = instanciateHandler(method);
            // Unlike the moments (before and after), some operations have similar designations (delete and undelete).
            // Then, we cannot use contains in a String. We shall compose a List of String.
            List<String> operations = method.Operations__c.toLowerCase().deleteWhitespace().split(',');
            callHandler(method, operations, callableClass);
        }
    }

    /**
	 * @description Instanciates and stores a handler class or get it from the Map if it has previously been.
	 * @param method Custom metadata containing information about the method to execute.
     * @return Instanciated class implementing Callable interface.
	 */
    private static Callable instanciateHandler(HandlerMethod__mdt method) {
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

    /**
	 * @description Calls the handler method to be executed according the Trigger context.
	 * @param method Custom metadata containing information about the method to execute.
     * @param operations Operation types (insert, update...) for which the method has to execute.
     * @param callableClass Class implementing the Callable interface that has been instanciated beforehand.
	 */
    private static void callHandler(HandlerMethod__mdt method, List<String> operations, Callable callableClass) {
        // The System.debug operations use the call method from the Callable interface implemented in the handler class.
        // The call method dynamically calls the informed method in the handler and returns back a state message.
        if (Trigger.isBefore && method.Moments__c.toLowerCase().deleteWhitespace().contains('before')) {
            if (Trigger.isInsert && operations.contains('insert')) {
                System.debug(callableClass.call(method.MethodName__c, parameters));
            }
            if (Trigger.isUpdate && operations.contains('update')) {
                System.debug(callableClass.call(method.MethodName__c, parameters));
            }
            if (Trigger.isDelete && operations.contains('delete')) {
                System.debug(callableClass.call(method.MethodName__c, parameters));
            }
        }
        if (Trigger.isAfter && method.Moments__c.toLowerCase().deleteWhitespace().contains('after')) {
            if (Trigger.isInsert && operations.contains('insert')) {
                System.debug(callableClass.call(method.MethodName__c, parameters));
            }
            if (Trigger.isUpdate && operations.contains('update')) {
                System.debug(callableClass.call(method.MethodName__c, parameters));
            }
            if (Trigger.isDelete && operations.contains('delete')) {
                System.debug(callableClass.call(method.MethodName__c, parameters));
            }
            if (Trigger.isUndelete && operations.contains('undelete')) {
                System.debug(callableClass.call(method.MethodName__c, parameters));
            }
        }
    }
    
}