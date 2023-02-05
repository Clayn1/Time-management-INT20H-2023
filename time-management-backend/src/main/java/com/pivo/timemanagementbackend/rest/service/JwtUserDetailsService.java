package com.pivo.timemanagementbackend.rest.service;

import com.pivo.timemanagementbackend.model.dto.UserCredentials;
import com.pivo.timemanagementbackend.model.dto.UserDetailsWithId;
import com.pivo.timemanagementbackend.rest.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class JwtUserDetailsService implements UserDetailsService {
    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetailsWithId loadUserByUsername(String email) throws UsernameNotFoundException {
        UserCredentials user = userRepository.findUserCredentialsByEmail(email);
        List<GrantedAuthority> authorityList = new ArrayList<>();
        authorityList.add(new SimpleGrantedAuthority("USER_ROLE"));
        UserDetailsWithId userDetailsWithId = new UserDetailsWithId(user.getEmail(), user.getPassword(), authorityList);
        userDetailsWithId.setId(user.getId());
        return userDetailsWithId;
    }
}
