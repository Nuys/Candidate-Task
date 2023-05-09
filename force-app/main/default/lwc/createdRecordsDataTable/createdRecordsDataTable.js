import { LightningElement, track, api} from 'lwc';
import getSObjectData from '@salesforce/apex/CreatedDataController.getSObjectData';
import View_Label from '@salesforce/label/c.View_Label';

export default class CreatedRecordsDataTable extends LightningElement {
    @api objectName;
    @api objectFields;

    @track sObjectData = [];
    @track columns = [];
    @track lastSelectedObject = '';
    @track dataRecieved = false;
    labels = {
        View_Label,
    };

    get dataTableTitle() {
        return this.labels.View_Label.replace('{0}', this.objectName);
    }

    connectedCallback(){
        if(!!this.objectName){
            this.getSobjectData(this.objectName);
        }
    }

    @api getSobjectData(sobjectApiName){
        this.dataRecieved = false;
        getSObjectData({ sObjectApiName: sobjectApiName, objectFields: this.objectFields })
        .then(response => {
            this.sObjectData = response.responseData.data;
            this.columns = response.responseData.columns;
            this.dataRecieved = true;
        })
        .catch(error => {
            console.error(error);
        });
    }

}