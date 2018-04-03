import { Detail } from './detail.domain';

export class MaterialRequisition {
    id: number;
    no: string;
    price: number;
    date: Date;
    remark: string;
    order: any;
    details: Detail[];
    order_id: number;
}