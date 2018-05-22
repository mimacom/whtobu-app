"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var nativescript_camera_1 = require("nativescript-camera");
var CameraComponent = /** @class */ (function () {
    function CameraComponent() {
        this.saveToGallery = true;
        this.keepAspectRatio = true;
        this.width = 300;
        this.height = 300;
    }
    CameraComponent.prototype.onTakePhoto = function () {
        var _this = this;
        var options = {
            width: this.width,
            height: this.height,
            keepAspectRatio: this.keepAspectRatio,
            saveToGallery: this.saveToGallery
        };
        nativescript_camera_1.takePicture(options)
            .then(function (imageAsset) {
            imageAsset.getImageAsync(function (image, error1) {
                _this.imageTaken = image;
                console.log(image);
                console.error(error1);
            });
            console.log("Size: " + imageAsset.options.width + "x" + imageAsset.options.height);
        }).catch(function (err) {
            console.log(err.message);
        });
    };
    CameraComponent.prototype.onRequestPermissions = function () {
        nativescript_camera_1.requestPermissions();
    };
    CameraComponent.prototype.onCheckForCamera = function () {
        var isCameraAvailable = nativescript_camera_1.isAvailable();
        console.log("Is camera hardware available: " + isCameraAvailable);
    };
    CameraComponent = __decorate([
        core_1.Component({
            moduleId: module.id,
            templateUrl: "./camera.component.html"
        })
    ], CameraComponent);
    return CameraComponent;
}());
exports.CameraComponent = CameraComponent;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiY2FtZXJhLmNvbXBvbmVudC5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbImNhbWVyYS5jb21wb25lbnQudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7QUFBQSxzQ0FBd0M7QUFHeEMsMkRBQWlGO0FBTWpGO0lBSkE7UUFNVyxrQkFBYSxHQUFZLElBQUksQ0FBQztRQUM5QixvQkFBZSxHQUFZLElBQUksQ0FBQztRQUNoQyxVQUFLLEdBQVcsR0FBRyxDQUFDO1FBQ3BCLFdBQU0sR0FBVyxHQUFHLENBQUM7SUFnQ2hDLENBQUM7SUE5QkcscUNBQVcsR0FBWDtRQUFBLGlCQW9CQztRQW5CRyxJQUFJLE9BQU8sR0FBRztZQUNWLEtBQUssRUFBRSxJQUFJLENBQUMsS0FBSztZQUNqQixNQUFNLEVBQUUsSUFBSSxDQUFDLE1BQU07WUFDbkIsZUFBZSxFQUFFLElBQUksQ0FBQyxlQUFlO1lBQ3JDLGFBQWEsRUFBRSxJQUFJLENBQUMsYUFBYTtTQUNwQyxDQUFDO1FBRUYsaUNBQVcsQ0FBQyxPQUFPLENBQUM7YUFDZixJQUFJLENBQUMsVUFBQSxVQUFVO1lBQ1osVUFBVSxDQUFDLGFBQWEsQ0FBQyxVQUFDLEtBQUssRUFBRSxNQUFNO2dCQUNuQyxLQUFJLENBQUMsVUFBVSxHQUFHLEtBQUssQ0FBQztnQkFDeEIsT0FBTyxDQUFDLEdBQUcsQ0FBQyxLQUFLLENBQUMsQ0FBQztnQkFDbkIsT0FBTyxDQUFDLEtBQUssQ0FBQyxNQUFNLENBQUMsQ0FBQztZQUMxQixDQUFDLENBQUMsQ0FBQztZQUVILE9BQU8sQ0FBQyxHQUFHLENBQUMsUUFBUSxHQUFHLFVBQVUsQ0FBQyxPQUFPLENBQUMsS0FBSyxHQUFHLEdBQUcsR0FBRyxVQUFVLENBQUMsT0FBTyxDQUFDLE1BQU0sQ0FBQyxDQUFDO1FBQ3ZGLENBQUMsQ0FBQyxDQUFDLEtBQUssQ0FBQyxVQUFBLEdBQUc7WUFDWixPQUFPLENBQUMsR0FBRyxDQUFDLEdBQUcsQ0FBQyxPQUFPLENBQUMsQ0FBQztRQUM3QixDQUFDLENBQUMsQ0FBQztJQUNQLENBQUM7SUFFRCw4Q0FBb0IsR0FBcEI7UUFDSSx3Q0FBa0IsRUFBRSxDQUFDO0lBQ3pCLENBQUM7SUFFRCwwQ0FBZ0IsR0FBaEI7UUFDSSxJQUFJLGlCQUFpQixHQUFHLGlDQUFXLEVBQUUsQ0FBQztRQUN0QyxPQUFPLENBQUMsR0FBRyxDQUFDLGdDQUFnQyxHQUFHLGlCQUFpQixDQUFDLENBQUM7SUFDdEUsQ0FBQztJQXBDUSxlQUFlO1FBSjNCLGdCQUFTLENBQUM7WUFDUCxRQUFRLEVBQUUsTUFBTSxDQUFDLEVBQUU7WUFDbkIsV0FBVyxFQUFFLHlCQUF5QjtTQUN6QyxDQUFDO09BQ1csZUFBZSxDQXFDM0I7SUFBRCxzQkFBQztDQUFBLEFBckNELElBcUNDO0FBckNZLDBDQUFlIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHtDb21wb25lbnR9IGZyb20gXCJAYW5ndWxhci9jb3JlXCI7XG5cbmltcG9ydCB7SW1hZ2VBc3NldH0gZnJvbSBcImltYWdlLWFzc2V0XCI7XG5pbXBvcnQge2lzQXZhaWxhYmxlLCByZXF1ZXN0UGVybWlzc2lvbnMsIHRha2VQaWN0dXJlfSBmcm9tIFwibmF0aXZlc2NyaXB0LWNhbWVyYVwiO1xuXG5AQ29tcG9uZW50KHtcbiAgICBtb2R1bGVJZDogbW9kdWxlLmlkLFxuICAgIHRlbXBsYXRlVXJsOiBcIi4vY2FtZXJhLmNvbXBvbmVudC5odG1sXCJcbn0pXG5leHBvcnQgY2xhc3MgQ2FtZXJhQ29tcG9uZW50IHtcbiAgICBwdWJsaWMgaW1hZ2VUYWtlbjogSW1hZ2VBc3NldDtcbiAgICBwdWJsaWMgc2F2ZVRvR2FsbGVyeTogYm9vbGVhbiA9IHRydWU7XG4gICAgcHVibGljIGtlZXBBc3BlY3RSYXRpbzogYm9vbGVhbiA9IHRydWU7XG4gICAgcHVibGljIHdpZHRoOiBudW1iZXIgPSAzMDA7XG4gICAgcHVibGljIGhlaWdodDogbnVtYmVyID0gMzAwO1xuXG4gICAgb25UYWtlUGhvdG8oKSB7XG4gICAgICAgIGxldCBvcHRpb25zID0ge1xuICAgICAgICAgICAgd2lkdGg6IHRoaXMud2lkdGgsXG4gICAgICAgICAgICBoZWlnaHQ6IHRoaXMuaGVpZ2h0LFxuICAgICAgICAgICAga2VlcEFzcGVjdFJhdGlvOiB0aGlzLmtlZXBBc3BlY3RSYXRpbyxcbiAgICAgICAgICAgIHNhdmVUb0dhbGxlcnk6IHRoaXMuc2F2ZVRvR2FsbGVyeVxuICAgICAgICB9O1xuXG4gICAgICAgIHRha2VQaWN0dXJlKG9wdGlvbnMpXG4gICAgICAgICAgICAudGhlbihpbWFnZUFzc2V0ID0+IHtcbiAgICAgICAgICAgICAgICBpbWFnZUFzc2V0LmdldEltYWdlQXN5bmMoKGltYWdlLCBlcnJvcjEpID0+IHtcbiAgICAgICAgICAgICAgICAgICAgdGhpcy5pbWFnZVRha2VuID0gaW1hZ2U7XG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGltYWdlKTtcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5lcnJvcihlcnJvcjEpO1xuICAgICAgICAgICAgICAgIH0pO1xuXG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJTaXplOiBcIiArIGltYWdlQXNzZXQub3B0aW9ucy53aWR0aCArIFwieFwiICsgaW1hZ2VBc3NldC5vcHRpb25zLmhlaWdodCk7XG4gICAgICAgICAgICB9KS5jYXRjaChlcnIgPT4ge1xuICAgICAgICAgICAgY29uc29sZS5sb2coZXJyLm1lc3NhZ2UpO1xuICAgICAgICB9KTtcbiAgICB9XG5cbiAgICBvblJlcXVlc3RQZXJtaXNzaW9ucygpIHtcbiAgICAgICAgcmVxdWVzdFBlcm1pc3Npb25zKCk7XG4gICAgfVxuXG4gICAgb25DaGVja0ZvckNhbWVyYSgpIHtcbiAgICAgICAgbGV0IGlzQ2FtZXJhQXZhaWxhYmxlID0gaXNBdmFpbGFibGUoKTtcbiAgICAgICAgY29uc29sZS5sb2coXCJJcyBjYW1lcmEgaGFyZHdhcmUgYXZhaWxhYmxlOiBcIiArIGlzQ2FtZXJhQXZhaWxhYmxlKTtcbiAgICB9XG59Il19