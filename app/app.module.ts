import {NgModule, NO_ERRORS_SCHEMA} from "@angular/core";
import {NativeScriptModule} from "nativescript-angular/nativescript.module";
import {AppRoutingModule} from "./app.routing";
import {AppComponent} from "./app.component";
import {CameraComponent} from "~/prediction/camera/camera.component";
import {ResultComponent} from "~/prediction/result/result.component";
import {PredictionComponent} from "~/prediction/prediction.component";
import {PredictionDataShareService} from "~/prediction/prediction-data-share.service";
import {RecognitionService} from "~/recognition.service";

// Uncomment and add to NgModule imports if you need to use two-way binding
// import { NativeScriptFormsModule } from "nativescript-angular/forms";

// Uncomment and add to NgModule imports  if you need to use the HTTP wrapper
// import { NativeScriptHttpModule } from "nativescript-angular/http";

@NgModule({
    bootstrap: [
        AppComponent
    ],
    imports: [
        NativeScriptModule,
        AppRoutingModule
    ],
    declarations: [
        AppComponent,
        CameraComponent,
        ResultComponent,
        PredictionComponent
    ],
    providers: [
        PredictionDataShareService,
        RecognitionService
    ],
    schemas: [
        NO_ERRORS_SCHEMA
    ]
})
/*
Pass your application module to the bootstrapModule function located in main.ts to start your app
*/
export class AppModule {
}
