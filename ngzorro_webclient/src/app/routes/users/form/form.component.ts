import {Component,OnInit} from '@angular/core';

import { ReuseTabService,ReuseTabMatchMode } from '@delon/abc';

@Component({
    templateUrl: './form.component.html'
})
export class UsersFormComponent implements OnInit {

    constructor(private reuseTabService: ReuseTabService) {
        this.reuseTabService.title ="用户表单" 
    }
    
    ngOnInit() {
        
    }
}