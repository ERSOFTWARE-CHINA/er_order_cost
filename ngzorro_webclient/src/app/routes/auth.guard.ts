import { Injectable } from '@angular/core';
import { Router, CanActivate } from '@angular/router';

import { ACLService } from '@delon/acl';
import { MenuService } from '@delon/theme';
 
@Injectable()
export class AuthGuard implements CanActivate {
 
    constructor(private router: Router,public aclSrv: ACLService,private menuSrv: MenuService) { }
 
    canActivate() {
        if (localStorage.getItem('currentToken')) {
            // logged in so return true
            return true;
        }
        // not logged in so redirect to login page
        this.router.navigate(['/login']);
        return false;
    }

}