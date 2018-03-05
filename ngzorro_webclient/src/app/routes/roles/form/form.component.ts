import {Component,OnInit} from '@angular/core';

import { ReuseTabService,ReuseTabMatchMode } from '@delon/abc';

@Component({
    templateUrl: './form.component.html'
})
export class RoleFormComponent implements OnInit {

    constructor(private reuseTabService: ReuseTabService) {
        this.reuseTabService.title ="角色表单" 
    }
    
    ngOnInit() {
        
    }
}