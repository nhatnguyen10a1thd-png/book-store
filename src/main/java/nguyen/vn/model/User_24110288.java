package nguyen.vn.model;

import java.util.Date;

public class User_24110288 {
    private int id;
    private String email;
    private String fullname;
    private String phone;
    private String passwd;
    private Date signupDate;
    private Date lastLogin;
    private boolean isAdmin;

    public User_24110288() {
    }

    public User_24110288(int id, String email, String fullname, String phone, String passwd, Date signupDate, Date lastLogin, boolean isAdmin) {
        this.id = id;
        this.email = email;
        this.fullname = fullname;
        this.phone = phone;
        this.passwd = passwd;
        this.signupDate = signupDate;
        this.lastLogin = lastLogin;
        this.isAdmin = isAdmin;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPasswd() { return passwd; }
    public void setPasswd(String passwd) { this.passwd = passwd; }

    public Date getSignupDate() { return signupDate; }
    public void setSignupDate(Date signupDate) { this.signupDate = signupDate; }

    public Date getLastLogin() { return lastLogin; }
    public void setLastLogin(Date lastLogin) { this.lastLogin = lastLogin; }

    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean admin) { isAdmin = admin; }
}
