package com.pivo.timemanagementbackend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EventDto {
    private String category;
    private Date date;
    private String reminder;
    private String email;
    private List<String> participants;
}
