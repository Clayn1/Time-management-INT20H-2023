package com.pivo.timemanagementbackend.model.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.pivo.timemanagementbackend.converter.StringToListConverter;
import com.pivo.timemanagementbackend.model.enums.Category;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.rest.core.annotation.RestResource;

import java.util.Date;
import java.util.List;

@Entity(name = "event")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
    private String name;
    private Category category;
    private String description;
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateStart;
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateEnd;
    private String reminder;
    @ManyToOne
    private User user;
    @OneToMany(mappedBy = "event", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @RestResource(exported = false)
    private List<InvitedUser> participants;
    @Convert(converter = StringToListConverter.class)
    private List<String> documents;

    @JsonIgnore
    public User getUser() {
        return user;
    }
}
