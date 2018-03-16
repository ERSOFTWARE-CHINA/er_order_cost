import {Component,OnInit} from '@angular/core';
import { FormGroup, FormBuilder, FormControl, Validators, FormArray } from '@angular/forms';
import { Router } from '@angular/router';

import { Observable } from 'rxjs/Observable';
import { ArrayObservable } from 'rxjs/observable/ArrayObservable';
import { map, delay, debounceTime } from 'rxjs/operators';

import { ReuseTabService,ReuseTabMatchMode } from '@delon/abc';
import { NzMessageService } from 'ng-zorro-antd';

import { UsersService } from '../service/users.service';
import { User } from '../domain/user.domain'; 
import { OrganizationsService } from '../../organizations/service/organizations.service';
import { RolesService } from '../../roles/service/roles.service'; 

@Component({
    selector: 'user-form',
    templateUrl: './form.component.html'
})
export class UsersFormComponent implements OnInit {

    form: FormGroup;
    user: User;
    card_title = "";
    // 机构树
    tree: any[] = [];
    // 角色列表
    roles: any[] = [];

    constructor(
        private reuseTabService: ReuseTabService,
        private fb: FormBuilder,
        private router: Router,
        private usersService: UsersService,
        private organsService: OrganizationsService,
        private rolesService: RolesService,
        private msg: NzMessageService
        ) {
    }
    
    ngOnInit() {
        this.setTitle();
        this.getTree();
        this.getRoles();
        this.form = this.fb.group({
            name : [null, Validators.compose([Validators.required, Validators.minLength(2), Validators.pattern('[\u4E00-\u9FA5-a-zA-Z0-9_]*$')]), this.nameValidator.bind(this)],
            email : [null,Validators.compose([Validators.required, Validators.minLength(2), Validators.pattern('#^[a-z_0-9.-]{1,64}@([a-z0-9-]{1,200}.){1,5}[a-z]{1,6}$#i')]), this.emailValidator.bind(this)],
            real_name : [null, Validators.compose([Validators.required, Validators.minLength(2), Validators.pattern('[\u4E00-\u9FA5-a-zA-Z0-9_]*$')])],
            position : [this.user? this.user.position : ''],
            actived : [this.user? this.user.actived : ''],
            is_admin : [this.user? this.user.is_admin : ''],
            organization : [this.user? this.user.organization : null],
            roles : [this.user? this.user.roles : '']
        });
    }

    getRoles() {
        this.rolesService.listAll()
            .then(resp => this.roles = resp.data)
            .catch((error) => {this.msg.error(error);})
    }

    getTree() {
        this.organsService.listTree()
            .then(resp => this.tree = [resp])
            .catch((error) => {this.msg.error(error);})
    }

    setTitle() {
        if (this.usersService.formOperation == "create") { 
            this.reuseTabService.title ="创建用户"; 
            this.card_title = "创建用户";
        }
        if (this.usersService.formOperation == "update") { 
            this.reuseTabService.title ="修改用户";
            this.card_title = "修改用户";
        }
    }

    _submitForm() {
        this.formatForm();
        console.log(this.user);
        this.usersService.add(this.user)
            .then(resp => {this.msg.success("用户: " + resp.data.name +" 已创建。");this.goBack()})
            .catch((error) => {this.msg.error(error)})  
    }

    goBack() {
        this.router.navigateByUrl('/users/page');
    }

    formatForm() {
        // 格式化form中的roles属性
        this.user = this.form.value;
        let roles = [];
        let role_ids = this.form["controls"]["roles"].value;
        for (var i=0; i<role_ids.length;i++) {
            let r = {id:  role_ids[i]}
            roles.push(r);   
        }
        this.user.roles = roles;

        // 格式化form中的organization属性
        let organ_id = this.form["controls"]["organization"].value.pop()
        if (organ_id != null) {
            let organ = { id: organ_id };
            this.user.organization = organ;
        }
    }

    //用户名username异步验证
    nameValidator = (control: FormControl): Observable<any>  => {
        // this.waiting = true
        return control.valueChanges.pipe(
            debounceTime(200),
            map((value) => {
                // this.waiting = true
                this.usersService.checkUsernameAlreadyExists(control.value)
                    .then(result => {
                // this.waiting = false
                if (result.error) {control.setErrors({ checked: true, error: true })} else if (!control.value){control.setErrors({ required: true })}  else {control.setErrors(null);};})

                
            })
        )
    }

    //邮箱email异步验证
    emailValidator = (control: FormControl): Observable<any>  => {
        // this.waiting = true
        return control.valueChanges.pipe(
            debounceTime(200),
            map((value) => {
                // this.waiting = true
                this.usersService.checkEmailAlreadyExists(control.value)
                    .then(result => {
                // this.waiting = false
                if (result.error) {control.setErrors({ checked: true, error: true })} else if (!control.value){control.setErrors({ required: true })}  else {control.setErrors(null);};})

                
            })
        )
    }
}