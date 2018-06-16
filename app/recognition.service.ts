import {Injectable} from "@angular/core";
import * as uuid from "nativescript-uuid";
import {Observable} from 'rxjs'
import * as dialogs from "ui/dialogs";

require("nativescript-nodeify");
import AWS = require("aws-sdk");

@Injectable()
export class RecognitionService {

    private bucketName: string = 'whtobu';
    private bucketFolder: string = 'rekognition';

    detectObjects(image: any): Observable<any> {

        console.log('Call detect objects with image:', image);

        AWS.config.update({
            region: 'eu-west-1',
            credentials: new AWS.Credentials('', '')
        });

        AWS.config.apiVersions = {
            rekognition: '2016-06-27',
        };

        let rekognition = new AWS.Rekognition();

        return Observable.create(function (observer) {

            let detectParams = {
                Image: {
                    Bytes: new Buffer(image, 'base64')
                }
            };

            rekognition.detectLabels(detectParams, function (error, response) {
                if (error) {
                    dialogs.alert({
                        title: "Error",
                        message: error + "",
                        okButtonText: "OK"
                    }).then(() => {
                        console.log("Dialog closed!");
                    });

                    console.log('Error from Rekognition', error, error.stack); // an error occurred
                    observer.error(error);
                    observer.complete();
                } else {
                    console.log('Got response:', response);
                    observer.next(response);
                    observer.complete();
                }
            });
        });
    }
}