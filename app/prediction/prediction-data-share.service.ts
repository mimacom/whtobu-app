import {Injectable} from "@angular/core";

@Injectable()
export class PredictionDataShareService {

    private results: Array<any>;

    getResults() {
        return this.results;
    }

    storeResults(results: Array<any>) {
        this.results = results;
    }
}