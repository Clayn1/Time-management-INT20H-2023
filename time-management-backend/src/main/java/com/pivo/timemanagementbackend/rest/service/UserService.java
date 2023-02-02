package com.pivo.timemanagementbackend.rest.service;

import com.pivo.timemanagementbackend.model.dto.UserData;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.rest.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public UserData getUserByEmail(String email) {
        User userByEmail = userRepository.findUserByEmail(email);
        return new UserData(
                userByEmail.getEmail(),
                userByEmail.getName(),
                userByEmail.getEvents(),
                userByEmail.getParticipateIn()
        );
    }

    public User getFullUserByEmail(String email) {
        return userRepository.findUserByEmail(email);
    }
}
