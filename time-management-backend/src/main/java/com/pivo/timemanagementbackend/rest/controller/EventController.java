package com.pivo.timemanagementbackend.rest.controller;

import com.pivo.timemanagementbackend.model.dto.EventDto;
import com.pivo.timemanagementbackend.model.dto.EventPreview;
import com.pivo.timemanagementbackend.model.dto.EventWithEmailDto;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.rest.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/event")
public class EventController {
    @Autowired
    private EventService eventService;

    @GetMapping("/{id}")
    public EventWithEmailDto findEventById(@PathVariable("id") Integer id) {
        return eventService.findEventById(id);
    }

    @GetMapping
    public List<EventPreview> getEvents(@RequestParam(value = "category", required = false) String category,
                                        @RequestParam(value = "name", required = false) String name,
                                        @RequestParam(value = "date", required = false) Date date,
                                        @RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
        return eventService.findEventPreviewsWithFilter(token, name, category, date);
    }

    @PostMapping
    public ResponseEntity<Event> createEvent(@RequestBody EventDto eventDto,
                             @RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
        return new ResponseEntity<>(eventService.createEvent(token, eventDto), HttpStatus.CREATED);
    }

    @PutMapping
    public ResponseEntity<Event> updateEvent(@RequestBody EventDto eventDto,
                             @RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
        return ResponseEntity.ok(eventService.updateEvent(token, eventDto));
    }

    @DeleteMapping("/{eventId}")
    public ResponseEntity<?> removeEvent(@PathVariable("eventId") Integer eventId) {
        eventService.removeEvent(eventId);
        return ResponseEntity.ok().build();
    }
}
