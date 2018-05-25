import {Component, OnInit} from "@angular/core";
import {PredictionDataShareService} from "~/prediction/prediction-data-share.service";
import {Router} from "@angular/router";
import {ObservableArray} from "tns-core-modules/data/observable-array";

@Component({
    moduleId: module.id,
    templateUrl: "./result.component.html",
    styleUrls: ['./result.component.css']
})
export class ResultComponent implements OnInit {

    private _dataItems: ObservableArray<any>;

    constructor(
        private router: Router,
        private store: PredictionDataShareService
    ) {
        console.log(store.getResults());
    }

    get dataItems(): ObservableArray<any> {
        return this._dataItems;
    }

    ngOnInit() {
        this._dataItems = new ObservableArray(this.store.getResults());
    }

    onItemTap(event) {
        console.log(event);
    }
}