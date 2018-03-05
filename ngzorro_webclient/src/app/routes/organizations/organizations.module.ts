import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { SharedModule } from '@shared/shared.module';

import { OrganizationsFormComponent } from './form/form.component';
import { OrganizationsComponent } from './organizations.component';
import { OrganizationsListComponent } from './list/list.component';
import { organizationsRoutes} from './organizations.routes';

// import { UsersService } from './users.service';

// import { MainPipe } from '../pipes/pipe.module';

@NgModule({
    imports: [
      CommonModule,
      SharedModule,
      FormsModule,
      ReactiveFormsModule,
    //   MainPipe,
      RouterModule.forChild(organizationsRoutes)
    ],
    declarations: [
      OrganizationsComponent,
      OrganizationsFormComponent,
      OrganizationsListComponent
    ],
    providers: [
    //   UserManagementService,
      // ConfirmationService
    ]
  })
  export class OrganizationsModule { }
  
