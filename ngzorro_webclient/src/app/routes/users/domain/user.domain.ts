export class User {
    id: number;
    name: string;
    email: string;
    real_name: string;
    position: string;
    is_admin: boolean;
    actived: boolean;
    roles: any[];
    avatar :string;
    organization: any;
    // 设置默认值
    constructor() { 
    }
}