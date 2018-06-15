import {Injectable} from "@angular/core";
import * as uuid from "nativescript-uuid";
import {Observable} from 'rxjs'
require("nativescript-nodeify");
import AWS = require("aws-sdk");
import * as dialogs from "ui/dialogs";

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

        let params = {
            Bucket: this.bucketName,
            Key: this.bucketFolder + '/' + uuid.getUUID(),
            Body: image,
            ContentEncoding: 'base64',
            ContentType: 'image/jpeg'
        };

        let rekognition = new AWS.Rekognition();
        let s3 = new AWS.S3();

        return Observable.create(function(observer) {

            console.log('s3.putObject');
            s3.putObject(params, function (err, data) {
                if (err) {
                    console.log('Got an error:', err);
                    observer.error(err);
                    observer.complete();
                } else {
                    console.log('Successfully uploaded photo from bucket');

                    let detectParams = {
                        Image: {
                            S3Object: {
                                Bucket: params.Bucket,
                                Name: params.Key
                            },
                        }
                    };

                    //if upload Successfully detect faces will work
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
                }
            });
        });
    }
}