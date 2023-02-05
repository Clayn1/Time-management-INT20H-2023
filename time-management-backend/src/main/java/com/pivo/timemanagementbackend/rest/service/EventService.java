package com.pivo.timemanagementbackend.rest.service;

import com.pivo.timemanagementbackend.model.dto.EventDto;
import com.pivo.timemanagementbackend.model.dto.EventPreview;
import com.pivo.timemanagementbackend.model.dto.EventWithEmailDto;
import com.pivo.timemanagementbackend.model.dto.UserData;
import com.pivo.timemanagementbackend.model.entity.Event;
import com.pivo.timemanagementbackend.model.entity.InvitedUser;
import com.pivo.timemanagementbackend.model.entity.User;
import com.pivo.timemanagementbackend.model.enums.Category;
import com.pivo.timemanagementbackend.rest.repository.EventRepository;
import com.pivo.timemanagementbackend.util.JwtTokenUtil;
import org.apache.commons.lang3.EnumUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class EventService {
    private final Logger logger = LoggerFactory.getLogger(EventService.class);
    @Autowired
    private S3BucketStorageService s3;
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
        logger.info("findEventPreviewsWithFilter: token:{}, name:{}, category:{}, date:{}", token, name, category, date);
        String email = jwtTokenUtil.getUsernameFromToken(token);
        Category categoryMapped = EnumUtils.isValidEnum(Category.class, StringUtils.toRootUpperCase(category))
                ? Category.valueOf(StringUtils.toRootUpperCase(category))
                : null;
        List<EventPreview> eventPreviewsWithFilter = eventRepository
                .findEventPreviewsWithFilter(email, categoryMapped, name, date);
        List<EventPreview> acceptedEventPreviewsWithFilter = eventRepository
                .findAcceptedEventPreviewsWithFilter(email, categoryMapped, name, date);
        if (acceptedEventPreviewsWithFilter.size() > 0) {
            eventPreviewsWithFilter.addAll(acceptedEventPreviewsWithFilter);
        }
        return eventPreviewsWithFilter;
    }

    public Event createEvent(String token, EventDto event) {
        User user = new User();
        user.setEmail(jwtTokenUtil.getUsernameFromToken(token));
        user.setId(jwtTokenUtil.getIdFromToken(token));
        Event savedEvent = eventRepository.save(mapDtoToEvent(event, user));
        if (event.getParticipants() != null) {
            List<InvitedUser> invitedUsers = invitationService.inviteUsers(savedEvent.getId(), event.getParticipants());
            savedEvent.setParticipants(invitedUsers);
        }
        if (event.getDocuments() != null) {
            for (MultipartFile document : event.getDocuments()) {
                savedEvent.getDocuments().add(s3.uploadFile(document));
            }
        }
        return savedEvent;
    }
    public Event updateEvent(String token, EventDto event) {
        User user = new User();
        user.setEmail(jwtTokenUtil.getUsernameFromToken(token));
        user.setId(jwtTokenUtil.getIdFromToken(token));
        Event savedEvent = eventRepository.save(mapDtoToEvent(event, user));
        if (event.getDocuments() != null) {
            for (MultipartFile document : event.getDocuments()) {
                savedEvent.getDocuments().add(s3.uploadFile(document));
            }
        }
        return savedEvent;
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
