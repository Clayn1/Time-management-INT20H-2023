package com.pivo.timemanagementbackend.rest.service;

import com.pivo.timemanagementbackend.model.dto.AuthResponse;
import com.pivo.timemanagementbackend.model.dto.UserData;
import com.pivo.timemanagementbackend.model.dto.UserLogin;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.rest.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public void createUser(UserLogin newUser, AuthResponse authResponse) {
        User user = new User();
        user.setEmail(newUser.getEmail());
        user.setName(newUser.getName());
        user.setPassword(new BCryptPasswordEncoder().encode(newUser.getPassword()));
        try {
            userRepository.save(user);
            authResponse.setIsError(false);
        } catch (Exception e) {
            authResponse.setIsError(true);
            authResponse.setErrorMessage("Email is already used");
        }
    }

    public UserData getUserByEmail(String email) {
        return userRepository.findUserByEmail(email);
    }
}
