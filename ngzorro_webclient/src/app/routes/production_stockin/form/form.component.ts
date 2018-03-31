import {Component,OnInit} from '@angular/core';
import { FormGroup, FormBuilder, FormControl, Validators, FormArray, EmailValidator } from '@angular/forms';
import { Router } from '@angular/router';

import { Observable } from 'rxjs/Observable';
import { ArrayObservable } from 'rxjs/observable/ArrayObservable';
import { map, delay, debounceTime } from 'rxjs/operators';

import { ReuseTabService,ReuseTabMatchMode } from '@delon/abc';
import { NzMessageService } from 'ng-zorro-antd';

import { ProductionStockinService } from '../service/production_stockin.service';
import { ProductionStockin } from '../domain/production_stockin.domain'; 
import { ProductionService } from '../../production/service/production.service'; 
import { OrderService } from '../../order/order-service/order.service';

@Component({
    selector: 'production_stockin-form',
    templateUrl: './form.component.html'
})
export class ProductionStockinFormComponent implements OnInit {

    form: FormGroup;
    productionStockin: ProductionStockin = new ProductionStockin();
    card_title = "";
    // 产品列表
    productions: any[] = [];
    // 订单列表
    orders: any[] =[];
 
    constructor(
        private reuseTabService: ReuseTabService,
        private fb: FormBuilder,
        private router: Router,
        private psiService: ProductionStockinService,
        private productionService: ProductionService,
        private orderService: OrderService,
        private msg: NzMessageService
        ) { }
    
    ngOnInit() {
        this.setTitle();
        this.initData();
        this.initForm();
    }

    // 初始化表单
    initForm() {
        this.form = this.fb.group({
            no : [null, Validators.compose([Validators.required, Validators.minLength(2), Validators.pattern('[\u4E00-\u9FA5-a-zA-Z0-9_]*$')]), this.noValidator.bind(this)],
            amount : [this.productionStockin? this.productionStockin.amount : null, [Validators.required, this.validateNumber.bind(this)]],
            unit : [this.productionStockin? this.productionStockin.unit : null],
            date : [this.productionStockin? this.productionStockin.date : null],
            remark : [this.productionStockin? this.productionStockin.remark : null],
            production : [this.productionStockin? this.productionStockin.production_id : null, [Validators.required]],
            order : [this.productionStockin? this.productionStockin.order_id : null, [Validators.required]]
        });
        this.form.controls["no"].setValue(this.productionStockin? this.productionStockin.no : null)
    }
    
    getProductions() {
        return this.productionService.listAll()
            .then(resp => this.productions = resp.data)
            .catch((error) => {this.msg.error(error);})
    }

    getOrders() {
        return this.orderService.listAll()
            .then(resp => this.orders = resp.data)
            .catch((error) => {this.msg.error(error);})
    }

    setTitle() {
        if (this.psiService.formOperation == "create") { 
            this.reuseTabService.title ="创建产品入库"; 
            this.card_title = "创建产品入库";
        }
        if (this.psiService.formOperation == "update") { 
            this.reuseTabService.title ="修改产品入库";
            this.card_title = "修改产品入库";
        }
    }

    _submitForm() {
        for (const i in this.form.controls) {
            this.form.controls[ i ].markAsDirty();
        }
        if (this.form.invalid) return ;
        let op = this.psiService.formOperation;
        
        if (op == 'create') {
            this.psiService.add(this.productionStockin).then(resp => {
                if (resp.error) { 
                    this.msg.error(resp.error);
                } else {
                    this.msg.success('入库信息 ' + resp.data.no + ' 已创建！');
                    this.goBack();
                }
                }).catch(error => this.msg.error(error));
        }
        if (op == 'update') this.psiService.update(this.productionStockin).then(resp => {
            if (resp.error) { 
                this.msg.error(resp.error);
            } else {
                this.msg.success('入库信息 ' + resp.data.no + ' 已更新！');
                this.goBack();
            }
            }).catch(error => this.msg.error(error));
    }

    goBack() {
        this.router.navigateByUrl('/production_stockin/page');
    }

    //单号no异步验证
    noValidator = (control: FormControl): Observable<any>  => {
        return control.valueChanges.pipe(
            debounceTime(200),
            map((value) => {
                let obj = {no: control.value, id: this.productionStockin.id? this.productionStockin.id: -1}; //如果为新增的情况，id参数设置为-1传递给后台
                this.psiService.checkNoAlreadyExists(obj)
                    .then(result => {
                        if (result.error) {
                            control.setErrors({ checked: true, error: true })
                        } else if (!control.value) {
                            control.setErrors({ required: true })
                        }  else {control.setErrors(null);};}
                    )   
            })
        )
    }
        
    //数字验证
    validateNumber(c: FormControl) {
        return c.value > 0 ? null : {validateNumber: true}
    };

    // 初始化form所需的所有数据
    initData() {
        if (this.psiService.formOperation == "update") {
            this.productionStockin = this.psiService.productionStockin;
        }
        this.getOrders();
        this.getProductions();
    }

}