/* tslint:disable */
/* eslint-disable */
// Generated using typescript-generator version 2.19.577 on 2021-07-19 15:50:40.

export interface AppVersion {
    buildTimestamp?: Nullable<string>;
    buildUserEmail?: Nullable<string>;
    buildUserName?: Nullable<string>;
    commitId?: Nullable<string>;
    commitTimestamp?: Nullable<string>;
}

export interface NdcRelatedEntities {
    ndc: string;
    scds: Scd[];
}

export interface Scd {
    rxcui: string;
    name: string;
    prescribableName: string;
    rxtermForm: string;
    dosageForm: string;
    ingrSetRxcui: string;
    availableStrengths: string;
    qualDistinct: string;
    quantity: string;
    humanDrug: boolean;
    vetDrug: boolean;
    unquantifiedFormRxcui: string;
    suppress: string;
}

export type Nullable<T> = T | null | undefined;
