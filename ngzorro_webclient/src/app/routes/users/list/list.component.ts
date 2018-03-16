import {Component,OnInit} from '@angular/core';
import { NzMessageService } from 'ng-zorro-antd';
import { _HttpClient } from '@delon/theme';
import { tap } from 'rxjs/operators';

import { UsersService } from '../service/users.service';
import { OrganizationsService } from '../../organizations/service/organizations.service';
import { UserStatusPipe } from '../../../pipes/pipes'; 

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
    // 机构树
    tree: any[] = [];



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
        private usersService: UsersService,
        private organsService: OrganizationsService
        ) {}

    ngOnInit() {
        this.getData();
        this.getTree();
    }

    getData() {
        this.formatForm()
        this.loading = true;
        // console.log(this.q + "改变前");
        this.q.organization = this.q.organization instanceof Array ? this.q.organization.pop() : null
        console.log(this.q);
        this.usersService.listOnePage(this.q)
                         .then(resp =>  {this.data = resp.data;this.total = resp.total_entries; this.loading = false;})
                         .catch((error) => {this.msg.error(error); this.loading = false;})
    }

    getTree() {
        this.organsService.listTree()
                          .then(resp => this.tree = [resp])
                          .catch((error) => {this.msg.error(error); this.loading = false;})
    }

    // 获取机构id
    _console(value) {
        // console.log(value.pop())
        console.log(this.q)
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

    formatForm() {
        if ((this.q.name == null)||(this.q.name == "")){delete this.q.name}
        if (this.q.actived == null){delete this.q.actived}
        if ((this.q.real_name == null)||(this.q.real_name == "")){delete this.q.real_name}
        if ((this.q.email == null)||(this.q.email == "")){delete this.q.email}
        if ((this.q.position == null)||(this.q.position == "")){delete this.q.position}
        if (this.q.organization_id == null){delete this.q.organization_id}
    }
}