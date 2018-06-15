import {Component} from "@angular/core";

import {ImageAsset} from "image-asset";
import {takePicture} from "nativescript-camera";
import {Router} from "@angular/router";
import {PredictionDataShareService} from "~/prediction/prediction-data-share.service";
import {RecognitionService} from "~/recognition.service";
import * as ImageSourceModule from "tns-core-modules/image-source";

@Component({
    moduleId: module.id,
    templateUrl: "./camera.component.html",
    styleUrls: ['./camera.component.css']
})
export class CameraComponent {
    public imageTaken: ImageAsset;
    public saveToGallery: boolean = false;
    public busy: boolean = false;
    public backgroundClass: string = 'icon-tap';

    constructor(
        private router: Router,
        private store: PredictionDataShareService,
        private recognition: RecognitionService
    ) {

    }

    onTakePhoto() {

        let options = {
            saveToGallery: this.saveToGallery,
            keepAspectRatio: true,
            width: 300
        };

        takePicture(options)
            .then(imageAsset => {
                let backgroundClass = this.backgroundClass;
                this.backgroundClass = '';
                this.busy = true;
                this.imageTaken = imageAsset;

                imageAsset.getImageAsync(image => {
                    let imageSource = ImageSourceModule.fromNativeSource(image);
                    let encodedString = imageSource.toBase64String("jpeg");

                    console.log('Selected image;', encodedString);
                    this.recognition.detectObjects(encodedString).subscribe(
                        x => console.log('onNext: %s', x),
                        e => {
                            console.log('onError: %s', e);

                            this.busy = false;
                            this.backgroundClass = backgroundClass;
                            this.router.navigate([
                                '/'
                            ]);
                        },
                        () => {
                            console.log('onCompleted');

                            this.busy = false;
                            this.backgroundClass = backgroundClass;
                            this.store.storeResults([
                                {
                                    name: "iPhone 8 Plus",
                                    description: "Color Black",
                                    rating: '90%'
                                },
                                {
                                    name: "iPhone 7 Plus",
                                    description: "Color Black",
                                    rating: '85%'
                                },
                                {
                                    name: "Galaxy S9",
                                    description: "Color Red",
                                    rating: '60%'
                                }
                            ]);

                            this.router.navigate([
                                '/result'
                            ]);
                        });
                });
            }).catch(err => {
            console.log(err.message);
        });
    }
}