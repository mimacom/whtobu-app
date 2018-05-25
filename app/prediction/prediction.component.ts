import {Component} from "@angular/core";
import {ActivatedRoute} from "@angular/router";

@Component({
    moduleId: module.id,
    templateUrl: "./prediction.component.html",
    styleUrls: ['./prediction.component.css']
})
export class PredictionComponent {

    constructor(
        private route: ActivatedRoute
    ) {

    }

}