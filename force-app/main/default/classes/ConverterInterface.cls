public interface ConverterInterface {
    
    /**
    * @author Evgeniy Dobritsa
    * @date 2023/05/08
    * @description interface to convert SObjects
    * @param objectList - map of objects
    * @param metaData - 
    */
    List<SObject> convert(List<Object> objectList, List<Map<String, String>> mappingList);
    
}