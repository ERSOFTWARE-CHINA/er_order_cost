import { Detail } from './detail.domain';

export class MaterialRequisition {
    id: number;
    no: string;
    picker: string;
    date: Date;
    remark: string;
    order: any;
    details: Detail[];
    order_id: number;
}