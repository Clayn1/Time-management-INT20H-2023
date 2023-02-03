package com.pivo.timemanagementbackend.rest.controller;

import com.pivo.timemanagementbackend.model.dto.UserData;
import com.pivo.timemanagementbackend.rest.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/{email}")
    public UserData getUser(@PathVariable("email") String email) {
        return userService.getUserByEmail(email);
    }
}
