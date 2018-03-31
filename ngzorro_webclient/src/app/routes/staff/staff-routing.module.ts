import { NgModule } from '@angular/core';
import { SharedModule } from '@shared/shared.module';
import { Routes, RouterModule } from '@angular/router';

import { StaffListComponent } from "./staff-list/staff-list.component";
import { StaffFormComponent } from "./staff-form/staff-form.component";


const routes: Routes = [{ 
  path: '', 
  children: [
      { path: '', redirectTo: 'page', pathMatch: 'full' },
      { path: 'page', component:  StaffListComponent},
      { path: 'form', component:  StaffFormComponent},
  ]
}];

@NgModule({
  imports: [ RouterModule.forChild(routes) ],
  exports: [ RouterModule ],
})
export class StaffRoutingModule { }
