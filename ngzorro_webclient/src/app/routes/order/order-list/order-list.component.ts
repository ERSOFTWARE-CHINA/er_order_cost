import { Component, OnInit } from '@angular/core';
import { _HttpClient } from '@delon/theme';
import { Router } from '@angular/router';
import { OrderService } from '../order-service/order.service';
import { NzMessageService } from 'ng-zorro-antd';

@Component({
  selector: 'app-order-list',
  templateUrl: './order-list.component.html',
})
export class OrderListComponent implements OnInit {

    constructor(
        private http: _HttpClient,
        public msg: NzMessageService,
        private orderService: OrderService,
        private router: Router
    ) { }

    ngOnInit() {
        this.getData();
    }

    _onReuseInit() {
        this.getData();
    }

    expandForm = false;
    loading = false;
    q: any = {
        page_index: 1,
        page_size: 15,
        sort_field: "date",
        sort_direction: "desc",
        pno: null,
        name: null,
        date: null,
        project: null
    };
    // 记录总数
    total: number;
     // 列表
     data: any[] = [];
     // 删除对象
     delObj = null;
 
    add() {
        this.router.navigateByUrl('/orders/form');
    }

    formatForm() {
        if ((this.q.pno == null)||(this.q.pno == "")){delete this.q.pno}
        if ((this.q.date == null)||(this.q.date == "")){delete this.q.date}
        if ((this.q.name == null)||(this.q.name == "")){delete this.q.name}
    }

    getData(){
        this.formatForm()
        this.loading = true;
        this.orderService.listOnePage(this.q)
                         .then(resp => {
                             if (resp.error) {
                                this.msg.error(resp.error);
                                this.loading = false;
                             } else {
                                this.data = resp.data;this.total = resp.total_entries; 
                                this.loading = false;
                             }
                         })
                         .catch((error) => {this.msg.error(error); this.loading = false;})
    }

}
