/**
* @author Evgeniy Dobritsa
* @date 2023/05/09
* @description get SObject data to display records on data-table
* Test classes: CreatedDataControllerTest
*/
public with sharing class CreatedDataController {

    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/09
    * @param sObjectApiName - SObject api name
    * @param objectFields - String with fields separated by coma
    * @description get SObject data to display records on data-table
    * @return ResponseBuilder - response with SObject records and columns details
    */
    @AuraEnabled(cacheable=false)
    public static ResponseBuilder getSObjectData(String sObjectApiName, String objectFields) {
        ResponseBuilder response;
        try{
            Map<String, Object> resultMap = new Map<String, Object>();
            
            List<SObject> sObjectList = Database.query('SELECT ' +  objectFields + ' FROM '+ sObjectApiName + ' ORDER BY CreatedDate DESC LIMIT 20');
        
            List<String> fieldNames = objectFields.split(', ');

            List<Map<String, Object>> data = new List<Map<String, Object>>();

            for (SObject selectedSObject : sObjectList) {
                Map<String, Object> row = new Map<String, Object>();
                for (String fieldName : fieldNames) {
                    Object fieldValue = selectedSObject.get(fieldName);
                    row.put(fieldName, fieldValue);
                }
                data.add(row);
            }

            resultMap.put('data', data);
            resultMap.put('columns', getSObjectColumns(sObjectList[0], fieldNames));

            response = new ResponseBuilder(true, resultMap);
        }catch(Exception ex){
            response = new ResponseBuilder(false, ex.getMessage() + ' ' + ex.getStackTraceString());
        }

        return response;
    }

    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/09
    * @param sObjectType - SObject Type to getting fields map
    * @param objectFields - String with fields separated by coma
    * @description get Sobject columns(data table required data)
    * @return List<TableColumn> - Wrapped columnes details
    */
    public static List<TableColumn> getSObjectColumns(SObject sObjectType, List<String> fieldNames) {
        List<TableColumn> columns = new List<TableColumn>();
        Map<String, SObjectField> fieldsMap = sObjectType.getSObjectType().getDescribe().fields.getMap();
        for (SObjectField field : fieldsMap.values()) {
            if (fieldNames.contains(field.getDescribe().getName()) && field.getDescribe().isAccessible() 
                && field.getDescribe().isCreateable() && field.getDescribe().isUpdateable()) {
                String fieldName = field.getDescribe().getName();
                String label = field.getDescribe().getLabel();
                Schema.DisplayType type = field.getDescribe().getType();
                columns.add(new TableColumn(label, fieldName, type.name()));
            }
        }
        return columns;
    }

    public class TableColumn {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String fieldName { get; set; }
        @AuraEnabled
        public String type { get; set; }
    
        public TableColumn(String label, String fieldName, String type) {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
        }
    }

}