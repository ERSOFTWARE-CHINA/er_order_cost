import {Component,OnInit} from '@angular/core';
import { FormGroup, FormBuilder, FormControl, Validators, FormArray, EmailValidator } from '@angular/forms';
import { Router } from '@angular/router';

import { Observable } from 'rxjs/Observable';
import { ArrayObservable } from 'rxjs/observable/ArrayObservable';
import { map, delay, debounceTime } from 'rxjs/operators';

import { ReuseTabService,ReuseTabMatchMode } from '@delon/abc';
import { NzMessageService } from 'ng-zorro-antd';

import { StaffService } from '../service/staff.service';
import { Staff } from '../domain/staff.domain'; 
import { RolesService } from '../../roles/service/roles.service'; 
import { ProjectsService } from '../../projects/service/projects.service';

@Component({
    selector: 'staff-form',
    templateUrl: './staff-form.component.html'
})
export class StaffFormComponent implements OnInit {

    form: FormGroup;
    staff: Staff;
    card_title = "";


    constructor(
        private reuseTabService: ReuseTabService,
        private fb: FormBuilder,
        private router: Router,
        private staffService: StaffService,
        private msg: NzMessageService
        ) {
    }
    
    ngOnInit() {
        this.setTitle();
        if (this.staffService.formOperation == 'create') {this.staff=null;}
        if (this.staffService.formOperation == 'update') {this.initUpdate();}
        this.form = this.fb.group({
            name : [null, Validators.compose([Validators.required, Validators.minLength(2), Validators.pattern('[\u4E00-\u9FA5-a-zA-Z0-9_]*$')])],
            job_number : [null, Validators.compose([Validators.required,Validators.minLength(2),]),this.jobNumberValidator.bind(this)],
            sex : [this.staff? this.staff.sex : null],
            age : [this.staff? this.staff.sex : null]
            // type : [this.staff? this.staff.type : null],
        });
        this.form.controls["name"].setValue(this.staff? this.staff.name : "")
    }


    setTitle() {
        if (this.staffService.formOperation == "create") { 
            this.reuseTabService.title ="创建零配件"; 
            this.card_title = "创建零配件";
        }
        if (this.staffService.formOperation == "update") { 
            this.reuseTabService.title ="修改零配件";
            this.card_title = "修改零配件";
        }
    }

    _submitForm() {
        for (const i in this.form.controls) {
            this.form.controls[ i ].markAsDirty();
        }
        if (this.form.invalid) return ;

        let op = this.staffService.formOperation;
        if (op == 'create') this.staffService.add(this.form.value).then(resp => {
            if (resp.error) { 
                this.msg.error(resp.error);
            } else {
                this.msg.success('零配件 ' + resp.data.name + ' 已创建！');
                this.goBack();
            }
            }).catch(error => this.msg.error(error));
        if (op == 'update') this.staffService.update(this.staff.id, this.form.value).then(resp => {
            if (resp.error) { 
                this.msg.error(resp.error);
            } else {
                this.msg.success('零配件 ' + resp.data.name + ' 已更新！');
                this.goBack();
            }
            }).catch(error => this.msg.error(error));

    }

    goBack() {
        this.router.navigateByUrl('/staffs/page');
    }

    //用户名name异步验证
    nameValidator = (control: FormControl): Observable<any>  => {
        return control.valueChanges.pipe(
            debounceTime(200),
            map((value) => {
                let obj = {name: control.value, id: this.staff? this.staff.id: -1}; //如果为新增的情况，id参数设置为-1传递给后台
                this.staffService.checkNameAlreadyExists(obj)
                    .then(result => {
                if (result.error) {control.setErrors({ checked: true, error: true })} else if (!control.value){control.setErrors({ required: true })}  else {control.setErrors(null);};})   
            })
        )
    }

    jobNumberValidator = (control: FormControl): Observable<any> => {
        return control.valueChanges.pipe(
            debounceTime(200),
            map((value) => {
                let obj = {job_number: control.value, id: this.staff? this.staff.id: -1}; //如果为新增的情况，id参数设置为-1传递给后台
                this.staffService.checKJobNumberAlreadyExists(obj)
                 .then(result => {
                     if(result.error){
                        control.setErrors({ checked: true, error: true });
                     } else if(!control.value) {
                        control.setErrors({ required: true });
                     } else {
                        control.setErrors(null);
                     }
                 })
            })
        )
    }

    initUpdate() {
        this.staff = this.staffService.staff;
    }
}