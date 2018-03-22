import { Injectable } from '@angular/core';
import { Http, URLSearchParams, RequestOptions, Headers } from '@angular/http';
import { Subject } from 'rxjs/Subject';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';

import { baseUrl } from '../../../shared/shared.service';
import { getTokenOptions } from '../../pages/login/login.service';

@Injectable()
export class RolesService {

  constructor(private http: Http) {}
   
  url = baseUrl+"roles"
  perms_url =baseUrl +"permissions"

  // 所有角色不超过64个
  listAll() {
    return this.http.get(this.url+`?page_size=64`, getTokenOptions(null))
               .toPromise().then(res => {return res.json()})           
  }

  // 获取所有权限的列表
  listAllPerms() {
    return this.http.get(this.perms_url, getTokenOptions(null))
      .toPromise().then(res => {return res.json()}) 
  }
  
}