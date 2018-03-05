import {OrganizationsComponent} from './organizations.component';
import {OrganizationsListComponent} from './list/list.component';
import {OrganizationsFormComponent} from './form/form.component';

export const organizationsRoutes = [{
	path: '',
	component: OrganizationsComponent,
	children: [
		{ path: '', redirectTo: 'page', pathMatch: 'full' },
		{ path: 'page', component: OrganizationsListComponent },
		{ path: 'form', component: OrganizationsFormComponent },
	]
}];