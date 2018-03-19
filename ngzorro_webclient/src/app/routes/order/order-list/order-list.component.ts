import { Component, OnInit } from '@angular/core';
import { _HttpClient } from '@delon/theme';
import { Router } from '@angular/router';

@Component({
  selector: 'app-order-list',
  templateUrl: './order-list.component.html',
})
export class OrderListComponent implements OnInit {

    constructor(
        private http: _HttpClient,
        private router: Router
    ) { }

    ngOnInit() {
    }

    expandForm = false;
    loading = false;
    q: any = {
        pi: 1,
        ps: 10,
        sf: "name",
        sd: "desc",
        name: null,
        actived: null,
        real_name: null,
        email: null,
        position: null,
        organization_id: null
        // sorter: '',
        // status: null,
        // statusList: []
    };
    // 记录总数
    total: number;
    // 用户列表
    data: any[] = [];

    add() {
        this.router.navigateByUrl('/orders/form');
    }

    getData(){

    }

}
