public with sharing class CDER_ExceptionHandler extend Exception{

    static DEFAULT_ORIGIN='Salesforce';
    
    public static void logException(Exception e){
        logException(e,'',''.'','','');
    }

    public static void logException(Exception e, String cause){
        logException(e, cause, '','','','');
    }

    public static void logException(Exception e, String cause, String relatedToId){
        logException(e, cause, relatedToId,'','','');
    }

    public static void logException(Exception e, String cause)
    
    public static void logException(Exception e, String cause, String relatedToId,  String comp, String app, String origin,){
        try
        {
            //Create Platform Event and publish it
            CDER_Log_Exception_Event__e evt = new CDER_Log_Exception_Event__e();
            evt.ErrorCause__c = cause;
            evt.RecordId__c = relatedToId;
            evt.ExceptionMessage__c = e.getMessage();
            evt.ExceptionType__c = e.getTypeName();
            evt.ExceptionStackTrace__c = e.getStackTraceString();
            evt.LineNumber__c = e.getLineNumber();  
            evt.origin__c = if(String.isBlank(origin)?DEFAULT_ORIGIN: origin;       
            evt.OriginComponent__c ='';
            evt.OriginApplication__c='';
        }
        finally {

        }
    }
}
