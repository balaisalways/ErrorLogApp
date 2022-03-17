public with sharing class CDER_ErrorLoggerAction {

    @InvocableMethod(label='CDER Log Error' description='CDER Error Logger')
    public static void log(List<CDER_Log_Exception_Event__e> logEventList){
        CDER_ErrorLog__c errorLog = new CDER_ErrorLog__c();
        for(CDER_Log_Exception_Event__e evt :logEventList) {
            System.debug('###Log Platform Event captured: '+evt);
            errorLog.ErrorCause__c =  evt.ErrorCause__c;
            errorLog.ExceptionMessage__c = evt.ExceptionMessage__c;
            errorLog.ExceptionStackTrace__c = evt.ExceptionStackTrace__c;
            errorLog.ExceptionType__c = evt.ExceptionType__c;
            errorLog.LineNumber__c = evt.LineNumber__c;
            errorLog.OriginApplication__c = evt.OriginApplication__c;
            errorLog.OriginComponent__c = evt.OriginComponent__c;
            errorLog.RecordId__c = evt.RecordId__c;
            errorLog.Origin__c = evt.Origin__c;
        }
        try {
            insert errorLog;
        }
        catch(DMLException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }

}
