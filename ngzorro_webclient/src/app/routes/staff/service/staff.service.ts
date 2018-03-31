import { Injectable } from '@angular/core';
import { Http, URLSearchParams, RequestOptions, Headers } from '@angular/http';
import { Subject } from 'rxjs/Subject';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';

import { Staff } from '../domain/staff.domain';
import { baseUrl } from '../../../shared/shared.service';
import { getTokenOptions } from '../../pages/login/login.service';

@Injectable()
export class StaffService {

  constructor(private http: Http) {}
   
  url = baseUrl + "staffs"

  isUpdate = false;

  formOperation = 'create';
  
  staff : Staff = null;

  listOnePage(q) {
    return this.http.get(this.url, getTokenOptions(q))
               .toPromise().then(res => {return res.json()})           
  }

  // 所有角色不超过64个
  listAll() {
    return this.http.get(this.url+`?page_size=64`, getTokenOptions(null))
               .toPromise().then(res => {return res.json()})           
  }

  add(v): Promise<any>{ 
    let param = { staff: v} 
    return this.http.post(this.url, param, getTokenOptions(null))
               .map(response => response.json()).toPromise();
  }

  initUpdate(id){
    return this.http.get(this.url + `/${id}`, getTokenOptions(null))
               .map(response => response.json()).toPromise();
  }

  update(cid, v): Promise<any>{
    let obj = { staff: v} 
    return this.http.put(this.url + `/${cid}`,obj, getTokenOptions(null))
               .map(response => response.json()).toPromise();
  }

  delete(id: any) {
    return this.http.delete(this.url + `/${id}`, getTokenOptions(null))
               .map(response => response.json())
               .toPromise();
  }

  checkNameAlreadyExists(obj) {
    return this.http.get(baseUrl + `staffs/check/name`, getTokenOptions(obj)).map(response => response.json()).toPromise();
  }

  checKJobNumberAlreadyExists(obj) {
    return this.http.get(baseUrl + `staffs/check/jobNumber`, getTokenOptions(obj)).map(response => response.json()).toPromise();
  }
  
}