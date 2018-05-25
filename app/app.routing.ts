import { NgModule } from "@angular/core";
import { NativeScriptRouterModule } from "nativescript-angular/router";
import { Routes } from "@angular/router";
import {PredictionComponent} from "~/prediction/prediction.component";
import {CameraComponent} from "~/prediction/camera/camera.component";
import {ResultComponent} from "~/prediction/result/result.component";

const routes: Routes = [
    {
        path: "",
        component: PredictionComponent,
        children: [
            {
                path: "",
                component: CameraComponent
            },
            {
                path: "result",
                component: ResultComponent
            }
        ]
    }
];

@NgModule({
    imports: [NativeScriptRouterModule.forRoot(routes)],
    exports: [NativeScriptRouterModule]
})
export class AppRoutingModule { }