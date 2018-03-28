import { OrderDetail } from "./orderDetail.domain";

export class Order {
  id: number;
  name: string;
  pno: string;
  price: number;
  date: Date;
  remark: string;
  order: any;
  details: OrderDetail[];
  project_id: number;
}