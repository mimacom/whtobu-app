import {Component} from "@angular/core";

import {ImageAsset} from "image-asset";
import {takePicture} from "nativescript-camera";
import {Router} from "@angular/router";
import {PredictionDataShareService} from "~/prediction/prediction-data-share.service";

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
        private store: PredictionDataShareService
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
                this.backgroundClass = '';
                this.busy = true;
                this.imageTaken = imageAsset;

                setTimeout(() => {
                    this.busy = false;

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
                            description: "Color Black",
                            rating: '60%'
                        }
                    ]);

                    this.router.navigate([
                        '/result'
                    ]);
                }, 1000);
            }).catch(err => {
            console.log(err.message);
        });
    }
}