import { NgModule } from '@angular/core';
import { SharedModule } from '@shared/shared.module';

import { ProductionRoutingModule } from './production-routing.module';
import { ProductionListComponent } from './production-list/production-list.component';
import { ProductionFormComponent } from './production-form/production-form.component';


const COMPONENT_NOROUNT = [];

@NgModule({
  imports: [ SharedModule,ProductionRoutingModule],
  declarations: [ProductionListComponent, ProductionFormComponent],
 
})
export class ProdcutionModule { }
