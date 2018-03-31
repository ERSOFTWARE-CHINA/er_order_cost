import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { SharedModule } from '@shared/shared.module';

import { StaffRoutingModule } from './staff-routing.module';

import { StaffComponent } from './staff.component';
import { StaffListComponent } from './staff-list/staff-list.component';
import { StaffFormComponent } from './staff-form/staff-form.component';
import { StaffService } from './service/staff.service';
import { RolesService } from '../roles/service/roles.service';
import { MainPipe } from '../../pipes/pipes.module';

@NgModule({
  imports: [ SharedModule, StaffRoutingModule, MainPipe ],
  declarations: [
    StaffComponent,
    StaffListComponent,
    StaffFormComponent
  ],
  providers: [
    StaffService
    // ConfirmationService
  ]
})
export class StaffModule { }

