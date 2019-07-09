@IsTest
private class CallerTest {

    @IsTest
    private static void callHandlersTest() {
        Caller.callHandlers('Test', 'before', 'insert');
    }

    @IsTest
    private static void setParametersTestNull() {
        Caller.setParameters('null', 'null');
    }

    @IsTest
    private static void setParametersTestTriggerNew() {
        Caller.setParameters('Trigger.new', 'Trigger.new');
    }

    @IsTest
    private static void setParametersTestTriggerOld() {
        Caller.setParameters('Trigger.old', 'Trigger.old');
    }

    @IsTest
    private static void setParametersTestTriggerNewMap() {
        Caller.setParameters('Trigger.newMap', 'Trigger.newMap');
    }

    @IsTest
    private static void setParametersTestTriggerOldMap() {
        Caller.setParameters('Trigger.oldMap', 'Trigger.oldMap');
    }

    @IsTest
    private static void setParametersTestNone() {
        Caller.setParameters(null, null);
    }

    @IsTest
    private static void instanciateHandlerTestEmpty() {
        Map<String, Callable> instanciatedClasses = new Map<String, Callable> ();
        Callable callableClass = Caller.instanciateHandler('CallerMock', instanciatedClasses);
        System.assert(callableClass instanceOf CallerMock, 'No instanciated class or wrong type returned');
    }

    @IsTest
    private static void instanciateHandlerTestPopulated() {
        Map<String, Callable> instanciatedClasses = new Map<String, Callable> { 'CallerMock' => new CallerMock() };
        Callable callableClass = Caller.instanciateHandler('CallerMock', instanciatedClasses);
        System.assertEquals(instanciatedClasses.get('CallerMock'), callableClass, 'No instanciated class returned');
    }

}