package com.pivo.timemanagementbackend.rest.service;

import com.pivo.timemanagementbackend.model.dto.EventDto;
import com.pivo.timemanagementbackend.model.dto.EventPreview;
import com.pivo.timemanagementbackend.model.dto.EventWithEmailDto;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.model.entity.InvitedUser;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.model.enums.Category;
import com.pivo.timemanagementbackend.rest.repository.EventRepository;
import com.pivo.timemanagementbackend.util.JwtTokenUtil;
import org.apache.commons.lang3.EnumUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class EventService {
    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private InvitationService invitationService;

    public EventWithEmailDto findEventById(Integer id) {
        Event event = eventRepository.findById(id).orElse(null);
        if (event != null) {
            return new EventWithEmailDto(
                    event.getId(),
                    event.getName(),
                    event.getCategory(),
                    event.getDescription(),
                    event.getDateStart(),
                    event.getDateEnd(),
                    event.getReminder(),
                    event.getUser().getEmail(),
                    event.getParticipants(),
                    event.getDocuments()
            );
        } else {
            return null;
        }
    }

    public List<EventPreview> findEventPreviewsWithFilter(String token, String name, String category, Date date) {
        String email = jwtTokenUtil.getUsernameFromToken(token);
        Category categoryMapped = EnumUtils.isValidEnum(Category.class, category) ? Category.valueOf(category) : null;
        List<EventPreview> eventPreviewsWithFilter = eventRepository.findEventPreviewsWithFilter(email, categoryMapped, name, date);
        List<EventPreview> acceptedEventPreviewsWithFilter = eventRepository.findAcceptedEventPreviewsWithFilter(email, categoryMapped, name, date);
        if (acceptedEventPreviewsWithFilter.size() > 0) {
            eventPreviewsWithFilter.addAll(acceptedEventPreviewsWithFilter);
        }
        return eventPreviewsWithFilter;
    }

    public Event createEvent(String token, EventDto event) {
        String email = jwtTokenUtil.getUsernameFromToken(token);
        User user = new User();
        user.setEmail(email);
        Event savedEvent = eventRepository.save(mapDtoToEvent(event, user));
        List<InvitedUser> invitedUsers = invitationService.inviteUsers(savedEvent.getId(), event.getParticipants());
        savedEvent.setParticipants(invitedUsers);
        return savedEvent;
    }
    public Event updateEvent(String token, EventDto event) {
        String email = jwtTokenUtil.getUsernameFromToken(token);
        User user = new User();
        user.setEmail(email);
        return eventRepository.save(mapDtoToEvent(event, user));
    }
    public void removeEvent(Integer eventId) {
        eventRepository.deleteById(eventId);
    }
    private Event mapDtoToEvent(EventDto eventDto, User user) {
        Event event = new Event();
        event.setId(eventDto.getId());
        event.setName(eventDto.getName());
        event.setUser(user);
        event.setDateStart(eventDto.getDateStart());
        event.setDateEnd(eventDto.getDateEnd());
        event.setDescription(eventDto.getDescription());
        event.setCategory(Category.valueOf(eventDto.getCategory()));
        event.setReminder(eventDto.getReminder());
        return event;
    }
}
