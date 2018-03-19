import {Component,OnInit} from '@angular/core';
import { FormGroup, FormBuilder, FormControl, Validators, FormArray } from '@angular/forms';
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
        ) {
    }
    
    ngOnInit() {
        this.setTitle();
        this.form = this.fb.group({
            name : [null, Validators.compose([Validators.required, Validators.minLength(2), Validators.pattern('[\u4E00-\u9FA5-a-zA-Z0-9_]*$')]), this.nameValidator.bind(this)],
            perms_number : [this.project? this.project.deadline : 0],
            deadline : [this.project? this.project.deadline : ''],
            actived : [this.project? this.project.actived : null]
        });
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
        this.projectsService.add(this.project)
            .then(resp => {this.msg.success("项目: " + resp.data.name +" 已创建。");this.goBack()})
            .catch((error) => {this.msg.error(error)})  
    }

    goBack() {
        this.router.navigateByUrl('/projects/page');
    }


    nameValidator = (control: FormControl): Observable<any>  => {
        // this.waiting = true
        return control.valueChanges.pipe(
            debounceTime(200),
            map((value) => {
                // this.waiting = true
                this.projectsService.checkNameAlreadyExists(control.value)
                    .then(result => {
                // this.waiting = false
                if (result.error) {control.setErrors({ checked: true, error: true })} else if (!control.value){control.setErrors({ required: true })}  else {control.setErrors(null);};})

                
            })
        )
    }

}