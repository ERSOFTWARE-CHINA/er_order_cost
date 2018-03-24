import { NgModule } from '@angular/core';
import { SharedModule } from '@shared/shared.module';
import { SparepartListComponent } from './sparepart-list/sparepart-list.component';
import { SparepartFormComponent } from './sparepart-form/sparepart-form.component';
import { SparepartRoutingModule } from './sparepart-routing.module';


const COMPONENT_NOROUNT = [];

@NgModule({
  imports: [SharedModule, SparepartRoutingModule],
  declarations: [SparepartListComponent, SparepartFormComponent],

})
export class SparepartModule { }
