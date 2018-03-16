import { Injectable } from '@angular/core';
import { Http, URLSearchParams, RequestOptions, Headers } from '@angular/http';
import { Subject } from 'rxjs/Subject';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';

// import { User } from '../domain/user.domain';
import { baseUrl } from '../../../shared/shared.service';
import { getTokenOptions } from '../../passport/service/login.service';

// import { dateToString } from '../utils/utils'
//import { setTokenOptions } from '../_services/authentication.service';
@Injectable()
export class RolesService {

  constructor(private http: Http) {}
   
  url = baseUrl+"roles"

  // 所有角色不超过64个
  listAll() {
    return this.http.get(this.url+`?page_size=64`)
               .toPromise().then(res => {return res.json()})           
  }

  
}