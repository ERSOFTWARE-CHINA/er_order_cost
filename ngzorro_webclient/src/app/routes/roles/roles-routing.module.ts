import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { RoleComponent } from './roles.component';
import { RoleListComponent } from './list/list.component';
import { RoleFormComponent } from './form/form.component';

const routes: Routes = [{ 
    path: '', 
    component: RoleComponent,
    children: [
      { path: '', redirectTo: 'page', pathMatch: 'full', data: { translate: 'dashboard_analysis' }  },
      { path: 'page', component: RoleListComponent, data: { translate: 'dashboard_analysis' }  },
      { path: 'form', component: RoleFormComponent },
    ],
    data: { translate: 'dashboard_analysis' } 
}];

@NgModule({
  imports: [ RouterModule.forChild(routes) ],
  exports: [ RouterModule ]
})
export class RoleRoutingModule { }
