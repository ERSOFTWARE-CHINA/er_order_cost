import {Component,OnInit} from '@angular/core';

import { ReuseTabService,ReuseTabMatchMode } from '@delon/abc';

@Component({
    templateUrl: './form.component.html'
})
export class OrganizationsFormComponent implements OnInit {

    constructor(private reuseTabService: ReuseTabService) {
        this.reuseTabService.title ="机构表单" 
    }
    
    ngOnInit() {
        
    }
}