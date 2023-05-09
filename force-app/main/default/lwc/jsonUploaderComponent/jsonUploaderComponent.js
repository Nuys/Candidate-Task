import { LightningElement, track, api} from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createJSONRecords from '@salesforce/apex/DataConverterController.createJSONRecords';
import getContentDocBodyById from '@salesforce/apex/DataConverterController.getContentDocBodyById';
import Upload_JSON_File_Label from '@salesforce/label/c.Upload_JSON_File_Label';
import Process_Label from '@salesforce/label/c.Process_Label';
import Attach_correct_file from '@salesforce/label/c.Attach_correct_file_Label';

export default class JsonUploaderComponent extends LightningElement {
    
    @api objectName;
    @api objectFields;

    @track jsonFile;
    @track isValidJSON = false;

    labels = {
        Upload_JSON_File_Label,
        Process_Label,
        Attach_correct_file
    };

    get isDataExist(){
        return this.objectName && this.objectFields ? true : false;
    }

    get acceptedFormats(){
        return ['.json'];
    }

    get proccessLabel(){
        return this.labels.Process_Label
    }

    get uploadLabel(){
        return this.labels.Upload_JSON_File_Label
    }

    handleUploadFinished(event) {
        const uploadedFile = event.detail.files;
        if (uploadedFile.length > 0) {    
        let contentId = uploadedFile[0].documentId;
        getContentDocBodyById({cdId: contentId})
            .then((response) => {
                if(response.isSuccess) {
                    this.jsonFile = response.responseData;
                    if (this.jsonFile) {
                        this.isValidJSON = true;
                    } else {
                        this.showToastEvent('Error', this.labels.Attach_correct_file, 'error');
                    }
                } else {
                    console.log(response.errMessage);
                }
            })
        }
    }

    showToastEvent(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            })
        );
    }

    createRecordsByJSON(){
        createJSONRecords({ jsonData:  this.jsonFile})
        .then(response => {
            if (response && response.isSuccess) {
                this.showToastEvent('Success', response.message, 'success');
                const childComponent = this.template.querySelector('c-created-records-data-table');
                childComponent.getSobjectData(this.objectName);
            } else {
                this.showToastEvent('Error', response.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }
}