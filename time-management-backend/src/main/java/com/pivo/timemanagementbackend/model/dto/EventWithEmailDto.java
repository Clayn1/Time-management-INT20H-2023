package com.pivo.timemanagementbackend.model.dto;

import com.pivo.timemanagementbackend.model.entity.InvitedUser;
import com.pivo.timemanagementbackend.model.enums.Category;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EventWithEmailDto {
    private Integer id;
    private String name;
    private Category category;
    private String description;
    private Date dateStart;
    private Date dateEnd;
    private String reminder;
    private String email;
    private List<InvitedUser> participants;
    private List<String> documents;
}
