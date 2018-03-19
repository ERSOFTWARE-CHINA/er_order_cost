import { Injectable } from '@angular/core';
import { Http, Headers, Response, RequestOptions } from '@angular/http';
import { Observable } from 'rxjs';
import 'rxjs/add/operator/map';

import { baseUrl } from '../../../shared/shared.service';

export function getTokenOptions(paramsobj): RequestOptions{
    let headers = new Headers();
    let jwt = 'Bearer ' + localStorage.getItem('currentToken');
    headers.append('Authorization', jwt);
    headers.append('Content-Type', 'application/json');
    let options = new RequestOptions({ headers: headers, params: paramsobj });
    return options;
}
 
@Injectable()
export class AuthenticationService {
    public token: string;
 
    constructor(private http: Http) {
        // set token if saved in local storage
        var currentUser = JSON.parse(localStorage.getItem('currentUser'));
        this.token = currentUser && currentUser.token;
    }
 
    login(value): Observable<any> {
        let headers = new Headers();
        headers.append('Content-Type', 'application/json');
        let options = new RequestOptions({ headers: headers });
        return this.http.post(baseUrl + `login`, value, options)
            .map((response: Response) => {
                console.log("@@@@login ok@@@@")
                console.log(response.json())
                let error = response.json() && response.json().error;
                let token = response.json() && response.json().jwt;
                let username = response.json() && response.json().user && response.json().user.name;
                let email = response.json() && response.json().user && response.json().user.email;
                let perms = response.json() && response.json().perms;
                let avatar = response.json() && response.json().user && response.json().user.avatar;

              
                 if (!error && token && username && perms) {
                    this.token = token;
                    localStorage.setItem('currentToken', token);
                    localStorage.setItem('currentUsername', username);
                    localStorage.setItem('currentPerms', perms);
                    localStorage.setItem('username', username);
                    localStorage.setItem('email', email)
                    localStorage.setItem('avatar', avatar)
                    console.log("valid login!")
                    return true;
                } else {
                    console.log("invalid login!")
                    return false;
                }
            });
    }

    checkUsernameAlreadyExists(username) {
        return this.http.get(baseUrl + `users/username/${username}`).map(response => response.json()).toPromise();

    }

    checkEmailAlreadyExists(email) {
        return this.http.get(baseUrl + `users/email/${email}`, getTokenOptions(null)).map(response => response.json()).toPromise();

    }

    checkPassword(pwd) {

            return this.http.get(baseUrl + `users/checkpwd/${pwd}`, getTokenOptions(null))
                       .map(response => response.json()).toPromise();
          }

}

    