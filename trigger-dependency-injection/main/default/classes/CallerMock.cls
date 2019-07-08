public with sharing class CallerMock implements Callable {

    public static String mockingMethod(List<SObject> records, Map<Id, SObject> oldRecords) {
        return 'Method executed: CallerMock.mockingMethod';
    }
    
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'mockingMethod' {
                return mockingMethod((List<SObject>)arguments.get('parameter1'),
                                     (Map<Id, SObject>)arguments.get('parameter2'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}

}