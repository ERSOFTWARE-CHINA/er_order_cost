import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { OrderComponent } from './order.component';
import { OrderListComponent } from './order-list/order-list.component';
import { OrderFormComponent } from './order-form/order-form.component';

const routes: Routes = [{ 
    path: '', 
    component: OrderComponent,
    children: [
      { path: '', redirectTo: 'page', pathMatch: 'full', data: { translate: 'dashboard_analysis' }  },
      { path: 'page', component: OrderListComponent, data: { translate: 'dashboard_analysis' }  },
      { path: 'form', component: OrderFormComponent },
    ],
    data: { translate: 'dashboard_analysis' } 
}];

@NgModule({
  imports: [ RouterModule.forChild(routes) ],
  exports: [ RouterModule ]
})
export class OrderRoutingModule { }
