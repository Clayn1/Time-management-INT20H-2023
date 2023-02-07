package com.pivo.timemanagementbackend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserLogin {
    private Integer id;
    private String email;
    private String password;
    private String name;
    private String fbToken;
}
