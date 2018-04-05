import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, FormControl, Validators, FormArray } from '@angular/forms';
import { Router } from '@angular/router';

import { NzMessageService } from 'ng-zorro-antd';

import { MaterialRequisitionService } from '../service/material_requisition.service';
import { SparepartService } from '../../sparepart/service/sparepart.service';
import { OrderService } from '../../order/order-service/order.service';
import { MaterialRequisition } from '../domain/material_requisition.domain'; 
// import { stringToDate} from '../../../../utils/utils';

@Component({
    selector: 'material_requisition-form',
    templateUrl: './form.component.html'
})
export class MaterialRequisitionFormComponent implements OnInit {
    editIndex = -1;
    editObj = {};

    form: FormGroup;

    materialRequisition: MaterialRequisition;

    // 订单列表
    orders: any[] =[];
    // 配件列表
    spareparts: any[] =[];

    constructor(
        private fb: FormBuilder, 
        private router: Router, 
        private mrSrv: MaterialRequisitionService, 
        private orderService: OrderService,
        private sparepartService: SparepartService,
        private msg: NzMessageService) {}

    ngOnInit() {
        let op = this.mrSrv.formOperation;
        if (op == 'create') this.initCreate();
        if (op == 'update') this.initUpdate();
        this.form = this.fb.group({
            no: [this.materialRequisition? this.materialRequisition.no : '', [Validators.required, ,Validators.maxLength(30), Validators.minLength(4),
                                                              Validators.pattern('[\u4E00-\u9FA5-a-zA-Z0-9_]*$') ]],
            date: [this.materialRequisition? this.materialRequisition.date : '', [Validators.required]],
            price : [this.materialRequisition? this.materialRequisition.price : '', [Validators.required,this.validateNumber.bind(this)]],
            remark : [this.materialRequisition? this.materialRequisition.remark : ''],
            order : [this.materialRequisition? this.materialRequisition.order : '', [Validators.required]],

            details: this.fb.array([])
        });
        if (op == 'update'){
        this.materialRequisition.details? this.materialRequisition.details.forEach(i => {
            const field = this.createDetail();
            field.patchValue(i);
            this.details.push(field);
            // console.log(this.purchase.details);
            // console.log(i);
            field.controls["sparepart"].setValue(i.sparepart.name);
        }) : console.log("tihs contract has no details.");}

    }

    createDetail(): FormGroup {
        return this.fb.group({
            price: [ null, [ Validators.required ] ],
            amount: [ null, [ Validators.required ] ],
            total_price: [ null ],
            sparepart: [ null, [ Validators.required ] ]
        });
    }

    getOrders() {
        this.orderService.listAll()
        .then(resp => this.orders = resp.data)
        .catch((error) => {this.msg.error(error);})
    }

    getSpareparts() {
        this.sparepartService.listAll()
        .then(resp => this.spareparts = resp.data)
        .catch((error) => {this.msg.error(error);})
    }

    get details() { return this.form.controls.details as FormArray; }
    
    add() {
        this.details.push(this.createDetail());
        this.edit(this.details.length - 1);
    }

    del(index: number) {
        this.details.removeAt(index);
    }

    edit(index: number) {
        if (this.editIndex !== -1 && this.editObj) {
            this.details.at(this.editIndex).patchValue(this.editObj);
        }
        this.editObj = { ...this.details.at(index).value };
        this.editIndex = index;
    }

    save(index: number) {
        
        this.details.at(index).markAsDirty();
        if (this.details.at(index).invalid) return;
        let total = this.details.at(index)['controls']['price'].value * this.details.at(index)['controls']['amount'].value
        this.details.at(index)['controls']['total_price'].setValue(total)
        let a= this.details.at(index)['controls']['sparepart'].value
        this.editIndex = -1;
        
    }

    cancel(index: number) {
        
        if (!this.details.at(index).value.key) {
            this.del(index);
        } else {
            this.details.at(index).patchValue(this.editObj);
        }
        this.editIndex = -1;

    }

    _submitForm() {

        for (const i in this.form.controls) {
          this.form.controls[ i ].markAsDirty();
        }
        if (this.form.invalid) return ;
        if (this.form.valid) {
            this.formatForm() 
            let op = this.mrSrv.formOperation;
            if (op == 'create') this.mrSrv.add(this.form.value).then(resp => {
                if (resp.error) { 
                    this.msg.error(resp.error);
                } else {
                    this.msg.success('创建领料单 ' + resp.no + ' 成功！');
                }
                console.log(resp);this.goBack()}).catch(error => this.msg.error(error));
            if (op == 'update') this.mrSrv.update(this.materialRequisition.id, this.form.value).then(resp => {
                if (resp.error) { 
                    this.msg.error(resp.error);
                } else {
                    this.msg.success('更新领料单 ' + resp.no + ' 成功！');
                }
                this.goBack();}).catch(error => this.msg.error(error));
            
        }
        
    }

    goBack() {
        this.router.navigateByUrl('/material_requisition/page');
    }

    initCreate() {
        this.getOrders();
        this.getSpareparts();
    }

    initUpdate() {
        this.getOrders();
        this.getSpareparts();
        this.materialRequisition = this.mrSrv.materialRequisition;
    }

    formatForm() {
        // 根据后端格式，重新组装details参数
        let details = [];
        let form_details = this.form.controls["details"].value;
        for (const i in form_details) {
            let v = form_details[i]
            let sparepart = {name : form_details[i].sparepart} 
            v.sparepart = sparepart
            details.push(v)
            console.log(v)
        }
        this.form.controls["details"].setValue(details);
       
    }

    //数字验证
    validateNumber(c: FormControl) {
        return c.value > 0 ? null : {validateNumber: true}
    };
    

}