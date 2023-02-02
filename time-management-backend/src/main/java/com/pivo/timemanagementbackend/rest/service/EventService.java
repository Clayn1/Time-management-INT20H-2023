package com.pivo.timemanagementbackend.rest.service;

import com.pivo.timemanagementbackend.model.dto.EventDto;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.rest.repository.EventRepository;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EventService {
    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private UserService userService;

    public Event findEventById(Integer id) {
        return eventRepository.findEventById(id);
    }
    public List<Event> findEventsByUserEmailAndCategory(String email, String category) {
        if (StringUtils.isNotEmpty(category)) {
            return eventRepository.findEventsByUser_EmailAndCategory(email, category);
        } else {
            return eventRepository.findEventsByUser_Email(email);
        }
    }

    public Event createEvent(EventDto event) {
        User user = new User();
        user.setEmail(event.getEmail());
        Event event1 = new Event();
        event1.setUser(user);
        event1.setDate(event.getDate());
        event1.setCategory(event.getCategory());
        event1.setReminder(event.getReminder());
        return eventRepository.save(event1);
    }
}
