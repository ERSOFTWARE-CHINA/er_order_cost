import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { SharedModule } from '@shared/shared.module';

import { UsersRoutingModule } from './users-routing.module';

import { UsersComponent } from './users.component';
import { UsersListComponent } from './list/list.component';
import { UsersFormComponent } from './form/form.component';

@NgModule({
  imports: [ SharedModule, UsersRoutingModule ],
  declarations: [
    UsersComponent,
    UsersListComponent,
    UsersFormComponent
  ]
})
export class UsersModule { }

