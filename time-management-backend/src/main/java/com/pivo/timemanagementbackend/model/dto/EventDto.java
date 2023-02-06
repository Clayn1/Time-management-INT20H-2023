package com.pivo.timemanagementbackend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EventDto {
    private Integer id;
    private String name;
    private String category;
    private String description;
    private Date dateStart;
    private Date dateEnd;
    private String reminder;
    private List<String> participants;
    private List<String> documents;
}
