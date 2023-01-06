/* tslint:disable */
/* eslint-disable */
// Generated using typescript-generator version 2.19.577 on 2022-12-27 17:26:13.

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
    sbds: Sbd[];
}

export interface Sbd {
    rxcui: string;
    name: string;
    prescribableName: string;
    rxtermForm: string;
    dosageForm: string;
    availableStrengths: string;
    qualDistinct: string;
    quantity: string;
    humanDrug: boolean;
    vetDrug: boolean;
    unquantifiedFormRxcui: string;
    suppress: string;
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
