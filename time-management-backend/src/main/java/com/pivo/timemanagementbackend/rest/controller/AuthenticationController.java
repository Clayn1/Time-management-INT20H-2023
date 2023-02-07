package com.pivo.timemanagementbackend.rest.controller;

import com.pivo.timemanagementbackend.model.dto.AuthResponse;
import com.pivo.timemanagementbackend.model.dto.UserDetailsWithId;
import com.pivo.timemanagementbackend.model.dto.UserLogin;
import com.pivo.timemanagementbackend.rest.service.FirebaseMessagingService;
import com.pivo.timemanagementbackend.rest.service.JwtUserDetailsService;
import com.pivo.timemanagementbackend.rest.service.UserService;
import com.pivo.timemanagementbackend.util.JwtTokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.CookieClearingLogoutHandler;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.rememberme.AbstractRememberMeServices;
import org.springframework.web.bind.annotation.PathVariable;
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
    @Autowired
    private FirebaseMessagingService firebaseMessagingService;

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> loginUser(@RequestBody UserLogin user) {
        AuthResponse authResponse = new AuthResponse();
        try {
            Authentication auth = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(user.getEmail(), user.getPassword()));
            if (auth.isAuthenticated()) {
                UserDetailsWithId userDetails = userDetailsService.loadUserByUsername(user.getEmail());
                String token = "Bearer " + jwtTokenUtil.generateToken(userDetails);
                authResponse.setToken(token);
                authResponse.setIsError(false);
                if (StringUtils.isNotEmpty(user.getFbToken()))
                    firebaseMessagingService.addToken(user.getFbToken(), token);
                return ResponseEntity.ok(authResponse);
            } else {
                authResponse.setIsError(true);
                authResponse.setErrorMessage("Unauthorized");
                return new ResponseEntity<>(authResponse, HttpStatus.UNAUTHORIZED);
            }
        } catch (BadCredentialsException e) {
            e.printStackTrace();
            authResponse.setIsError(true);
            authResponse.setErrorMessage(e.getMessage());
            return new ResponseEntity<>(authResponse, HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            e.printStackTrace();
            authResponse.setIsError(true);
            authResponse.setErrorMessage("Email does not exist");
            return new ResponseEntity<>(authResponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> saveUser(@RequestBody UserLogin newUser) {
        AuthResponse authResponse = new AuthResponse();
        userService.createUser(newUser, authResponse);
        if (!authResponse.getIsError()) {
            UserDetailsWithId userDetails = userDetailsService.loadUserByUsername(newUser.getEmail());
            String token = "Bearer " + jwtTokenUtil.generateToken(userDetails);
            if (StringUtils.isNotEmpty(newUser.getFbToken()))
                firebaseMessagingService.addToken(newUser.getFbToken(), token);
            authResponse.setToken(token);
        }
        return ResponseEntity.ok(authResponse);
    }

    @PostMapping("/logout/{token}")
    public void logout(@PathVariable("token") String fbToken, HttpServletRequest request, HttpServletResponse response) {
        CookieClearingLogoutHandler cookieClearingLogoutHandler = new CookieClearingLogoutHandler(AbstractRememberMeServices.SPRING_SECURITY_REMEMBER_ME_COOKIE_KEY);
        SecurityContextLogoutHandler securityContextLogoutHandler = new SecurityContextLogoutHandler();
        cookieClearingLogoutHandler.logout(request, response, null);
        securityContextLogoutHandler.logout(request, response, null);
        firebaseMessagingService.removeToken(fbToken);
    }
}
