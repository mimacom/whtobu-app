import {Injectable} from "@angular/core";

@Injectable()
export class PredictionDataShareService {

    private results: any;

    getResults() {
        return this.results;
    }

    storeResults(results: any) {
        this.results = results;
    }
}