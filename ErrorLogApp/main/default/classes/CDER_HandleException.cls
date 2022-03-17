public class CDER_HandleException extends Exception{

    public static String DEFAULT_ORIGIN='Salesforce';
    
    public static void logException(Exception e){
        logException(e,'','','','','');
    }

    public static void logException(Exception e, String cause){
        logException(e, cause, '','','','');
    }

    public static void logException(Exception e, String cause, String relatedToId){
        logException(e, cause, relatedToId,'','','');
    }

    public static void logException(Exception e, String cause, String relatedToId, String app ) {
        logException(e, cause, relatedToId,app,'','');
    }

    public static void logException(Exception e, String cause, String relatedToId, String app, String comp ) {
        logException(e, cause, relatedToId,app,comp,'');
    }

    /*
     * The params to be passed are 
     * e - Exception object
     * cause - Provide specific details on what business funtion is done
     * relatedToId - Pass the Salesforce 18 digit record ID related to this which can provide more details, e.g. Case ID
     * app - Application, e.g., Cares
     * comp - Component, e.g Flow, LWC / APEX Controller
     * origin - Origin layer, e.g Salesforce or Mulesoft
     */
    public static void logException(Exception e, String cause, String relatedToId,  String app, String comp, String origin){
        try
        {
            //Create Platform Event and publish it
            CDER_Log_Exception_Event__e evt = new CDER_Log_Exception_Event__e();
            evt.ErrorCause__c = cause;
            evt.RecordId__c = relatedToId;
            evt.ExceptionMessage__c = e.getMessage();
            evt.ExceptionType__c = e.getTypeName();
            evt.ExceptionStackTrace__c = e.getStackTraceString();
            evt.LineNumber__c = String.valueOf(e.getLineNumber());  
            evt.origin__c = (String.isBlank(origin) == true)? DEFAULT_ORIGIN : origin;       
            evt.OriginComponent__c = comp;
            evt.OriginApplication__c = app;
            EventBus.publish(evt);
        }
        finally {

        }
    }
}
