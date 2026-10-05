package nguyen.vn.repository;

import nguyen.vn.model.User_24110288;

public interface IUserRepository_24110288 {
    User_24110288 login(String email, String password);
    boolean register(User_24110288 user);
    User_24110288 getUserById(int id);
}
