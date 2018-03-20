import {Component,OnInit} from '@angular/core';
import { FormGroup, FormBuilder, FormControl, Validators, FormArray, AbstractControl } from '@angular/forms';
import { Router } from '@angular/router';

import { Observable } from 'rxjs/Observable';
import { ArrayObservable } from 'rxjs/observable/ArrayObservable';
import { map, delay, debounceTime } from 'rxjs/operators';

import { ReuseTabService,ReuseTabMatchMode } from '@delon/abc';
import { NzMessageService } from 'ng-zorro-antd';

import { ProjectsService } from '../service/projects.service';
import { Project } from '../domain/project.domain'; 

@Component({
    selector: 'project-form',
    templateUrl: './form.component.html'
})
export class ProjectsFormComponent implements OnInit {

    form: FormGroup;
    project: Project;
    card_title = "";

    constructor(
        private reuseTabService: ReuseTabService,
        private fb: FormBuilder,
        private router: Router,
        private projectsService: ProjectsService,
        private msg: NzMessageService
        ) {}
    
    ngOnInit() {
        this.setTitle();
        if (this.projectsService.formOperation == 'create') this.project=null;
        if (this.projectsService.formOperation == 'update') this.initUpdate();
        this.form = this.fb.group({
            name : ["", Validators.compose([Validators.required, Validators.minLength(4), Validators.pattern('[\u4E00-\u9FA5-a-zA-Z0-9_]*$')]), this.nameValidator.bind(this)],
            perms_number : [this.project? this.project.perms_number : 0],
            deadline : [this.project? this.project.deadline : null],
            acitived : [this.project? this.project.acitived : null, Validators.required]
        });
        this.form.controls["name"].setValue(this.project? this.project.name : "")
    }

    setTitle() {
        if (this.projectsService.formOperation == "create") { 
            this.reuseTabService.title ="创建项目"; 
            this.card_title = "创建项目";
        }
        if (this.projectsService.formOperation == "update") { 
            this.reuseTabService.title ="修改项目";
            this.card_title = "修改项目";
        }
    }

    _submitForm() {
        for (const i in this.form.controls) {
            this.form.controls[ i ].markAsDirty();
        }
        if (this.form.invalid) return ;
        // if (this.form.valid) {
            let op = this.projectsService.formOperation;
            if (op == 'create') this.projectsService.add(this.form.value).then(resp => {
                if (resp.error) { 
                    this.msg.error(resp.error);
                } else {
                    this.msg.success('项目 ' + resp.data.name + ' 已创建！');
                    this.goBack();
                }
                }).catch(error => this.msg.error(error));
            if (op == 'update') this.projectsService.update(this.project.id, this.form.value).then(resp => {
                if (resp.error) { 
                    this.msg.error(resp.error);
                } else {
                    this.msg.success('项目 ' + resp.data.name + ' 已更新！');
                    this.goBack();
                }
                }).catch(error => this.msg.error(error));
        // }
    }

    goBack() {
        this.router.navigateByUrl('/projects/page');
    }

    nameValidator = (control: FormControl): Observable<any>  => {
        return control.valueChanges.pipe(
            debounceTime(200),
            map((value) => {
                let obj = {name: control.value, id: this.project? this.project.id: -1}; //如果为新增的情况，id参数设置为-1传递给后台
                this.projectsService.checkNameAlreadyExists(obj)
                    .then(result => {
                if (result.error) {control.setErrors({ checked: true, error: true })} else if (!control.value){control.setErrors({ required: true })}  else {control.setErrors(null);};})   
            })
        )
    }

    initUpdate() {
        this.project = this.projectsService.project;
    }

}