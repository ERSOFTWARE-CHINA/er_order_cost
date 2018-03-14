import {Component,OnInit} from '@angular/core';
import { NzMessageService } from 'ng-zorro-antd';
import { _HttpClient } from '@delon/theme';
import { tap } from 'rxjs/operators';

import { UsersService } from '../service/users.service';


@Component({
    selector: 'user-list',
    templateUrl: './list.component.html'
})
export class UsersListComponent implements OnInit {

    q: any = {
        pi: 1,
        ps: 10,
        sf: "name",
        sd: "desc",
        name: "",
        actived: null,
        real_name: "",
        email: "",
        position: "",
        organization: ""
        // sorter: '',
        // status: null,
        // statusList: []
    };
    // 记录总数
    total: number;
    data: any[] = [];
    loading = false;
    selectedRows: any[] = [];
    curRows: any[] = [];
    totalCallNo = 0;
    allChecked = false;
    indeterminate = false;
    // status = [
    //     { text: '关闭', value: false, type: 'default' },
    //     { text: '运行中', value: false, type: 'processing' },
    //     { text: '已上线', value: false, type: 'success' },
    //     { text: '异常', value: false, type: 'error' }
    // ];
    actived_status = [
        { text: '不限定', value: null },
        { text: '已激活', value: true },
        { text: '未激活', value: false }
    ]
    sortMap: any = {};
    expandForm = false;
    modalVisible = false;
    description = '';

    constructor(
        private http: _HttpClient, 
        public msg: NzMessageService,
        private usersService: UsersService
        ) {}

    ngOnInit() {
        this.getData();
    }

    getData() {
        this.loading = true;
        this.usersService.listOnePage(this.q)
                         .then(resp =>  {this.data = resp.data;this.total = resp.total_entries; this.loading = false;})
                         .catch((error) => {this.msg.error(error); this.loading = false;})
    }

    add() {
        this.modalVisible = true;
        this.description = '';
    }

    save() {
        this.loading = true;
        this.http.post('/rule', { description: this.description }).subscribe(() => {
            this.getData();
            setTimeout(() => this.modalVisible = false, 500);
        });
    }

    remove() {
        this.http.delete('/rule', { nos: this.selectedRows.map(i => i.no).join(',') }).subscribe(() => {
            this.getData();
            this.clear();
        });
    }

    approval() {
        // this.msg.success(`审批了 ${this.selectedRows.length} 笔`);
    }

    clear() {
        this.selectedRows = [];
        this.totalCallNo = 0;
        this.data.forEach(i => i.checked = false);
        this.refreshStatus();
    }

    checkAll(value: boolean) {
        this.curRows.forEach(i => {
            if (!i.disabled) i.checked = value;
        });
        this.refreshStatus();
    }

    refreshStatus() {
        const allChecked = this.curRows.every(value => value.disabled || value.checked);
        const allUnChecked = this.curRows.every(value => value.disabled || !value.checked);
        this.allChecked = allChecked;
        this.indeterminate = (!allChecked) && (!allUnChecked);
        this.selectedRows = this.data.filter(value => value.checked);
        this.totalCallNo = this.selectedRows.reduce((total, cv) => total + cv.callNo, 0);
    }

    sort(field: string, value: any) {
        this.sortMap = {};
        this.sortMap[field] = value;
        // this.q.sorter = value ? `${field}_${value}` : '';
        this.getData();
    }

    dataChange(res: any) {
        this.curRows = res;
        this.refreshStatus();
    }

    pageChange(pi: number): Promise<any> {
        this.q.pi = pi;
        this.loading = true;
        return new Promise((resolve) => {
            setTimeout(() => {
                this.loading = false;
                resolve();
            }, 500);
        });
    }

    reset(ls: any[]) {
        this.q.name = '';
        this.q.actived = null;
        this.q.real_name = "";
        this.q.email = "";
        this.q.position = "";
        this.q.organization = null;
        this.getData();
    }

    // submit() {
    //     console.log(this.q)
    // }
}