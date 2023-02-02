package com.pivo.timemanagementbackend.model.dto;

import com.pivo.timemanagementbackend.model.entity.Event;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserData {
    private String email;
    private String name;
    private List<Event> events;
    private List<Event> participateIn;
}
