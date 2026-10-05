package nguyen.vn.service;

import nguyen.vn.repository.IUserRepository_24110288;
import nguyen.vn.repository.UserRepository_24110288;
import nguyen.vn.model.User_24110288;

public class UserService_24110288 implements IUserService_24110288 {

    private final IUserRepository_24110288 userRepository = new UserRepository_24110288();

    @Override
    public User_24110288 login(String email, String password) {
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            return null;
        }
        return userRepository.login(email, password);
    }

    @Override
    public boolean register(User_24110288 user) {
        if (user == null || user.getEmail() == null || user.getPasswd() == null) {
            return false;
        }
        return userRepository.register(user);
    }

    @Override
    public User_24110288 getUserById(int id) {
        return userRepository.getUserById(id);
    }
}
