/**
 * @author Rémi Le Guin
 * @date 09/04/2019
 * @description Test class for the trigger handlers caller.
 */
@IsTest
private class TDI_Caller_Test {
    
    /**
     * @description Unit test the callHandlers method.
     */
    @IsTest
    private static void callHandlers_Test() {
        TDI_Caller.callHandlers('Test', 'before', 'insert');
    }
    
    /**
     * @description Functional test to check the case of calling a non-implemented method.
     */
    @IsTest
    private static void testNonImplementedMethodForCallerMock() {
        String exceptionThrown;
        
        Test.startTest();
        try {
            Callable callableClass = (Callable)Type.forName('TDI_Caller_Mock').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
        Test.stopTest();
        
        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
    }
    
    /**
     * @description Unit test the setParameters method when 'null' parameters are passed.
     */
    @IsTest
    private static void setParameters_TestNull() {
        TDI_Caller.setParameters('null', 'null');
    }
    
    /**
     * @description Unit test the setParameters method when Trigger.new parameters are passed.
     */
    @IsTest
    private static void setParameters_TestTriggerNew() {
        TDI_Caller.setParameters('Trigger.new', 'Trigger.new');
    }
    
    /**
     * @description Unit test the setParameters method when Trigger.old parameters are passed.
     */
    @IsTest
    private static void setParameters_TestTriggerOld() {
        TDI_Caller.setParameters('Trigger.old', 'Trigger.old');
    }
    
    /**
     * @description Unit test the setParameters method when Trigger.newMap parameters are passed.
     */
    @IsTest
    private static void setParameters_TestTriggerNewMap() {
        TDI_Caller.setParameters('Trigger.newMap', 'Trigger.newMap');
    }
    
    /**
     * @description Unit test the setParameters method when Trigger.oldMap parameters are passed.
     */
    @IsTest
    private static void setParameters_TestTriggerOldMap() {
        TDI_Caller.setParameters('Trigger.oldMap', 'Trigger.oldMap');
    }
    
    /**
     * @description Unit test the setParameters method when no parameters are passed.
     */
    @IsTest
    private static void setParameters_TestNone() {
        TDI_Caller.setParameters(null, null);
    }
    
    /**
     * @description Unit test the instanciateHandler method when no class is passed.
     */
    @IsTest
    private static void instanciateHandler_TestEmpty() {
        Map<String, Callable> instanciatedClasses = new Map<String, Callable> ();
        Callable callableClass = TDI_Caller.instanciateHandler('TDI_Caller_Mock', instanciatedClasses);
        System.assert(callableClass instanceOf TDI_Caller_Mock, 'No instanciated class or wrong type returned');
    }
    
    /**
     * @description Unit test the instanciateHandler method when a class is passed.
     */
    @IsTest
    private static void instanciateHandler_TestPopulated() {
        Map<String, Callable> instanciatedClasses = new Map<String, Callable> { 'TDI_Caller_Mock' => new TDI_Caller_Mock() };
        Callable callableClass = TDI_Caller.instanciateHandler('TDI_Caller_Mock', instanciatedClasses);
        System.assertEquals(instanciatedClasses.get('TDI_Caller_Mock'), callableClass, 'No instanciated class returned');
    }
    
    /**
     * @description Unit test the bypassAllExcept method with an existing method.
     */
    @IsTest
    private static void bypassAllExcept_Test() {
        TDI_Caller.bypassAllExcept(new List<String> { 'TDI_CallerMockMockingMethod' }, null);
    }

    /**
     * @description Unit test the bypassAllExcept method with an non-existent method.
     */
    @IsTest
    private static void bypassAllExcept_TestNonexistentMethod() {
        TDI_Caller.bypassAllExcept(new List<String> { 'NonexistentMethod' }, null);
    }

    /**
     * @description Unit test the bypassAllExcept method with an existing method and a calling trigger.
     */
    @IsTest
    private static void bypassAllExcept_TestWithCallingTrigger() {
        TDI_Caller.bypassAllExcept(new List<String> { 'TDI_CallerMockMockingMethod' }, 'Test');
    }

}
