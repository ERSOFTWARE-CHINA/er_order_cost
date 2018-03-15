import { Injectable } from '@angular/core';
import { Http, URLSearchParams, RequestOptions, Headers } from '@angular/http';
import { Subject } from 'rxjs/Subject';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';

import { User } from '../domain/user.domain';
import { baseUrl } from '../../../shared/shared.service';
import { getTokenOptions } from '../../passport/service/login.service';

// import { dateToString } from '../utils/utils'
//import { setTokenOptions } from '../_services/authentication.service';
@Injectable()
export class UsersService {

  constructor(private http: Http) {}
   
  url = baseUrl+"users"

  listOnePage(q) {
    let options = new RequestOptions({ params: q });
    // `?page=${q.pi}&page_size=${q.ps}&sort_field=${q.sf}&sort_direction=${q.sd}&username=${q.name}`
    return this.http.get(this.url, options)
               .toPromise().then(res => {return res.json()})           
  }

  add(v): Promise<any>{ 
    let obj = { user: v} 
    let param = JSON.stringify(obj);
    return this.http.post(this.url, param)
               .map(response => response.json()).toPromise();
  }

  delete(id: any) {
    return this.http.delete(this.url + `/${id}`)
               .map(response => response.json())               .toPromise();
  }

  isUpdate = false;
  isAudit = false;

  formOperation = 'create';
  updateUserManagement : User = null;

  //获取用户对象将提供给修改页面Form使用
  initUpdate(id){

    return this.http.get(this.url + `/${id}`)
               .map(response => response.json()).toPromise();
  }

  activate(id){
    return this.http.post(this.url + `/${id}`+"/activate", "")
    .map(response => response.json())
    .toPromise();
  }

  update(cid, v): Promise<any>{
    console.log("this is update")
    let obj = { user: v} 
    let param = JSON.stringify(obj);
    return this.http.post(this.url + `/${cid}`,param)
               .map(response => response.json()).toPromise();
  }

  changePwd(pwd){
    return this.http.post(this.url + `/changepwd/${pwd}`,"")
    .map(response => response.json()).toPromise();
  }

  getByName(name){
    return this.http.get(this.url + `/username/${name}`)
    .map(response => response.json()).toPromise();
  }

  uploadAvatar(token, file){

    const formData = new FormData();
    formData.append("avatar", file);

    return this.http.post(this.url + `/avatar/upload/${token}`,formData)
      .map(response => response.json()).toPromise();
  }

}