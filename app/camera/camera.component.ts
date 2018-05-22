import {Component} from "@angular/core";

import {ImageAsset} from "image-asset";
import {isAvailable, requestPermissions, takePicture} from "nativescript-camera";

@Component({
    moduleId: module.id,
    templateUrl: "./camera.component.html"
})
export class CameraComponent {
    public imageTaken: ImageAsset;
    public saveToGallery: boolean = true;
    public keepAspectRatio: boolean = true;
    public width: number = 300;
    public height: number = 300;

    onTakePhoto() {
        let options = {
            width: this.width,
            height: this.height,
            keepAspectRatio: this.keepAspectRatio,
            saveToGallery: this.saveToGallery
        };

        takePicture(options)
            .then(imageAsset => {
                imageAsset.getImageAsync((image, error1) => {
                    this.imageTaken = image;
                    console.log(image);
                    console.error(error1);
                });

                console.log("Size: " + imageAsset.options.width + "x" + imageAsset.options.height);
            }).catch(err => {
            console.log(err.message);
        });
    }

    onRequestPermissions() {
        requestPermissions();
    }

    onCheckForCamera() {
        let isCameraAvailable = isAvailable();
        console.log("Is camera hardware available: " + isCameraAvailable);
    }
}