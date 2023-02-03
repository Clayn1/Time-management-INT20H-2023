package com.pivo.timemanagementbackend.model.dto;

import com.pivo.timemanagementbackend.model.enums.Category;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EventPreview {
    private Integer id;
    private String name;
    private Date dateStart;
    private Date dateEnd;
    private Category category;
    private String email;
}
