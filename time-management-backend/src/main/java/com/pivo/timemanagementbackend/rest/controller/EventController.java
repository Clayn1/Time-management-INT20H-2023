package com.pivo.timemanagementbackend.rest.controller;

import com.pivo.timemanagementbackend.model.dto.EventDto;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.rest.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/event")
public class EventController {
    @Autowired
    private EventService eventService;

    @GetMapping("/{id}")
    public Event findEventById(@PathVariable("id") Integer id) {
        return eventService.findEventById(id);
    }

    @GetMapping("/email/{email}")
    public List<Event> findEventsByUserEmailAndCategory(@PathVariable("email") String email,
                                                        @RequestParam(value = "category", required = false) String category) {
        return eventService.findEventsByUserEmailAndCategory(email, category);
    }

    @PostMapping()
    public Event createEvent(@RequestBody EventDto eventDto) {
        return eventService.createEvent(eventDto);
    }

}
