package com.pivo.timemanagementbackend.rest.controller;

import com.pivo.timemanagementbackend.model.dto.EventDto;
import com.pivo.timemanagementbackend.model.dto.EventPreview;
import com.pivo.timemanagementbackend.model.dto.EventWithEmailDto;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.rest.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

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
    public List<EventWithEmailDto> getEvents(@RequestParam(value = "category", required = false) String category,
                                        @RequestParam(value = "name", required = false) String name,
                                        @RequestParam(value = "date", required = false) @DateTimeFormat(pattern="yyyy-MM-dd") Date date,
                                        @RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
        return eventService.findEventPreviewsWithFilter(token, name, category, date);
    }

    @PostMapping(consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<Event> createEvent(@RequestPart(name = "event") EventDto eventDto,
                                             @RequestPart(name = "documents") List<MultipartFile> documents,
                                             @RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
        return new ResponseEntity<>(eventService.createUpdateEvent(token, documents, eventDto), HttpStatus.CREATED);
    }

    @PutMapping(consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<Event> updateEvent(@RequestPart(name = "event") EventDto eventDto,
                                             @RequestPart(name = "documents") List<MultipartFile> documents,
                                             @RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
        return ResponseEntity.ok(eventService.createUpdateEvent(token, documents, eventDto));
    }

    @DeleteMapping("/{eventId}")
    public ResponseEntity<?> removeEvent(@PathVariable("eventId") Integer eventId) {
        eventService.removeEvent(eventId);
        return ResponseEntity.ok().build();
    }
}
