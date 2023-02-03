package com.pivo.timemanagementbackend.model.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonView;
import com.pivo.timemanagementbackend.model.View;
import com.pivo.timemanagementbackend.model.enums.InvitationStatus;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity(name = "invitation")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class InvitedUser {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;
    private InvitationStatus status = InvitationStatus.PENDING;
    @ManyToOne
    @JoinColumn(name = "user_email")
    private User user;
    @ManyToOne
    @JsonIgnore
    private Event event;
    @Temporal(TemporalType.TIMESTAMP)
    private Date issuedWhen;
}
