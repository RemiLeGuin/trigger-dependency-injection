public with sharing class Caller {
    
    public static void callHandlers(String callingTrigger) {
        
        List<HandlerMethod__mdt> methods = [SELECT DeveloperName, ClassName__c, MethodName__c, Moments__c, Operations__c
                                            FROM HandlerMethod__mdt
                                            WHERE Active__c = true AND CallingTrigger__c = :callingTrigger
                                            ORDER BY IndexOfExecution__c ASC];
        
        Map<String, Callable> instanciatedClasses = new Map<String, Callable> ();
        String currentClassName;
        for (HandlerMethod__mdt method : methods) {
            
            Callable callableClass;
            if (currentClassName == null || instanciatedClasses.get(method.ClassName__c) == null) {
                callableClass = (Callable)Type.forName(method.ClassName__c).newInstance();
                instanciatedClasses.put(method.ClassName__c, callableClass);
            } else {
                callableClass = instanciatedClasses.get(method.ClassName__c);
            }
            currentClassName = method.ClassName__c;
            
            List<String> operations = method.Operations__c.toLowerCase().deleteWhitespace().split(',');
            Map<String, Object> parameters = new Map<String, Object> {
                'records' => Trigger.new,
                'oldRecords' => Trigger.oldMap
            };
            
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
    
}