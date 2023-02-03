package com.pivo.timemanagementbackend.rest.controller;

import com.pivo.timemanagementbackend.model.dto.UserLogin;
import com.pivo.timemanagementbackend.rest.service.JwtUserDetailsService;
import com.pivo.timemanagementbackend.rest.service.UserService;
import com.pivo.timemanagementbackend.util.JwtTokenUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthenticationController {
    @Autowired
    private UserService userService;
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private JwtUserDetailsService userDetailsService;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @PostMapping("/login")
    public ResponseEntity<String> loginUser(@RequestBody UserLogin user) {
        try {
            Authentication auth = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(user.getEmail(), user.getPassword()));
            if (auth.isAuthenticated()) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());
                String token = "Bearer " + jwtTokenUtil.generateToken(userDetails);
                return ResponseEntity.ok(token);
            } else {
                return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
            }
        } catch (BadCredentialsException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<String> saveUser(@RequestBody UserLogin newUser) {
        userService.createUser(newUser);
        UserDetails userDetails = userDetailsService.loadUserByUsername(newUser.getEmail());
        String token = "Bearer " + jwtTokenUtil.generateToken(userDetails);
        return ResponseEntity.ok(token);

    }
}
