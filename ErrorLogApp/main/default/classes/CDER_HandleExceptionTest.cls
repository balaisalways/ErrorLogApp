@isTest(isParallel=true)
private class CDER_HandleExceptionTest {

    //This test asserts the log handler method is publishing Platform Event which is actively subscribed by flow
    @TestSetup
    static void makeData(){
        CDER_Log_Exception_Event__e evt = new CDER_Log_Exception_Event__e();
        evt.ExceptionType__c='Log exception.getTypeName()';
        evt.ErrorCause__c='Log exception.getCause(), make sure to set Cause before throwing';
        evt.ExceptionMessage__c='Log exception.getMessage() output';
        evt.ExceptionStackTrace__c = 'Log exception.getStackTraceString()';
        evt.LineNumber__c ='Log exception.getLineNumber()';
        evt.OriginComponent__c ='Salesforce Apex';
        evt.OriginApplication__c ='Some App Name';
        evt.Origin__c='Salesforce';
        List<CDER_Log_Exception_Event__e> listEvt = new List<CDER_Log_Exception_Event__e>();
        listEvt.add(evt);
        EventBus.publish(listEvt);
        Test.getEventBus().deliver(); 

        try {
            Integer i = 1/0;            
        } catch (Exception e) {
            CDER_HandleException.logException(e,'TestCause');
        }        
    }
    @isTest
    static void testSubscription(){
        try {
            Integer i = 1/0;            
        } catch (Exception e) {
            CDER_HandleException.logException(e,'TestCause');
        }
       // CDER_ErrorLog__c errLog = [SELECT id, ExceptionType__c FROM EventBusSubscriber where Topic='CDER_Log_Exception_Event__e' AND Type='ApexTrigger'].get(0);
       
       EventBusSubscriber subscriber = [SELECT id, status FROM EventBusSubscriber where Topic='CDER_Log_Exception_Event__e'].get(0);
        System.debug('***********subscriber:'+subscriber);

        /*Status can have any of the below value, to verify our Flow is actively listening, this value should be 'Running'
            Running—The subscriber is actively listening to events. If you modify the subscriber, the subscription continues to process events.
            Error— The subscriber was disconnected and stopped receiving published events. 
                    A trigger reaches this state when it exceeds the number of maximum retries with the 
                    EventBus.RetryableException. Trigger assertion failures and unhandled exceptions don’t 
                    cause the error state. We recommend limiting the retries to fewer than nine times to avoid reaching 
                    this state. When you fix and save the trigger, or for a managed package trigger, 
                    if you redeploy the package, the trigger resumes automatically from the tip, starting from new events. 
                    Also, you can resume a trigger subscription in the subscription detail page that you access 
                    from the platform event page.
            Suspended—The subscriber is disconnected and can’t receive events because a Salesforce admin suspended 
                    it or due to an internal error. You can resume a trigger subscription in the subscription detail 
                    page that you access from the platform event page. To resume a process, deactivate it and 
                    then reactivate it. If you modify the subscriber, the subscription resumes automatically from the 
                    tip, starting from new events.
        */
        System.assertEquals(subscriber.status, 'Running', 'CDER_Error_Logger.flow is not actively listening for Errors'); 

    }


    @isTest
    static void testPlatformEvent() {
        Test.startTest();

        List<CDER_ErrorLog__c> evt = [Select id from CDER_ErrorLog__c];
        System.debug('****EVT:'+evt);
        Test.stopTest();
    }
    
}
