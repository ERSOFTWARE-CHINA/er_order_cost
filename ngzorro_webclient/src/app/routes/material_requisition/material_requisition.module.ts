import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { SharedModule } from '@shared/shared.module';


import { MaterialRequisitionComponent } from './material_requisition.component';
import { MaterialRequisitionFormComponent } from './form/form.component';
import { MaterialRequisitionListComponent } from './list/list.component';
import { MaterialRequisitionRoutes} from './material_requisition.routes';

import { MaterialRequisitionService } from './service/material_requisition.service';
import { OrderService } from '../order/order-service/order.service';
import { SparepartService } from '../sparepart/service/sparepart.service';

@NgModule({
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule.forChild(MaterialRequisitionRoutes)
  ],
  declarations: [
    MaterialRequisitionComponent,
    MaterialRequisitionFormComponent,
    MaterialRequisitionListComponent
  ],
  providers: [
    MaterialRequisitionService,
    OrderService,
    SparepartService
  ]
})
export class MaterialRequisitionModule { }