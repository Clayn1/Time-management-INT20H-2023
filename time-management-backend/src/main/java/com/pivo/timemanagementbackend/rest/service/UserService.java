package com.pivo.timemanagementbackend.rest.service;

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

    public User createUser(UserLogin newUser) {
        User user = new User();
        user.setEmail(newUser.getEmail());
        user.setName(newUser.getName());
        user.setPassword(new BCryptPasswordEncoder().encode(newUser.getPassword()));
        return userRepository.save(user);
    }

    public UserData getUserByEmail(String email) {
        return userRepository.findUserByEmail(email);
    }
}
