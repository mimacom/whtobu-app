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

    private labels: ObservableArray<any>;
    private text: ObservableArray<any>;

    constructor(
        private router: Router,
        private store: PredictionDataShareService
    ) {
        console.log(store.getResults());
    }

    get getLabels(): ObservableArray<any> {
        return this.labels;
    }

    get getText(): ObservableArray<any> {
        return this.text;
    }

    ngOnInit() {
        this.labels = new ObservableArray(this.store.getResults().labels);

        let text = [];

        for (let item of this.store.getResults().text) {
            if (item.Type == 'LINE') {
                text.push(item);
            }
        }

        this.text = new ObservableArray(text);
    }

    onItemTap(event) {
        console.log(event);
    }
}