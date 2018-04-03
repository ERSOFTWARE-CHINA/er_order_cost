import { MaterialRequisitionComponent } from './material_requisition.component';
import { MaterialRequisitionListComponent } from './list/list.component';
import { MaterialRequisitionFormComponent } from './form/form.component';

export const MaterialRequisitionRoutes = [{
	path: '',
	component: MaterialRequisitionComponent,
	children: [
		{ path: '', redirectTo: 'page', pathMatch: 'full' },
		{ path: 'page', component: MaterialRequisitionListComponent },
		{ path: 'form', component: MaterialRequisitionFormComponent },
	]
}];