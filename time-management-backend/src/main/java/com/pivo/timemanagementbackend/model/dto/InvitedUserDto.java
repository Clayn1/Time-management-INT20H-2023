package com.pivo.timemanagementbackend.model.dto;

import com.pivo.timemanagementbackend.model.enums.Category;
import com.pivo.timemanagementbackend.model.enums.InvitationStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class InvitedUserDto {
    private Integer invitationId;
    private InvitationStatus status;
    private String email;
    private Integer eventId;
    private String eventName;
    private Category category;
    private Date dateStart;
    private Date dateEnd;
    private Date issuedWhen;
}
