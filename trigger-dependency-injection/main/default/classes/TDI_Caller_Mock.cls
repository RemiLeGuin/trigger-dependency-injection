/**
 * @author Rémi Le Guin
 * @date 09/04/2019
 * @description Mock (but not for an HTTP callout) to be used for the test class for the trigger handlers caller.
 */
public with sharing class TDI_Caller_Mock implements Callable {

    /**
     * @description Mocking method for the test class.
     * @param action List of SObject records.
     * @param arguments Map of a previous version of SObject records.
     * @return The result of the method invocation.
     */
    public static String mockingMethod(List<SObject> records, Map<Id, SObject> oldRecords) {
        return 'Method executed: TDI_Caller_Mock.mockingMethod';
    }
    
    /**
     * @description Provides functionality that other classes or packages can utilize and build upon.
     * @param action The behavior for the method to exhibit.
     * @param arguments Arguments to be used by the specified action.
     * @return The result of the method invocation.
     */
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
    
    /**
     * @description Throws new exceptions.
     */
    public class ExtensionMalformedCallException extends Exception {}

}